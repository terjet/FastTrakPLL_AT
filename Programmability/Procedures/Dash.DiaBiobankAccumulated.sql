SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[DiaBiobankAccumulated] AS
BEGIN

  SELECT 

    Report.PartitionKey( Dataset.CenterId) AS PartitionKey, 
    Report.RowKeyReverse( Dataset.TimeAxis ) AS RowKey,
    'WW' AS TimeResolution,
    Dataset.*,
    DataSource.*

  FROM 

(  
  SELECT WeekList.StartTime AS TimeAxis, AggByCenter.CenterId, AggByCenter.n
  FROM
  (
    SELECT StartTime FROM Report.TimePeriods ml
    WHERE PeriodType = 'WEEK' AND StartTime > DATEADD(MM,-36, GETDATE() ) AND StartTime < GETDATE()
  ) WeekList

  CROSS APPLY

  ( SELECT CenterId, n FROM 

    ( SELECT pas.CenterId, COUNT(*) AS n from

      ( SELECT PersonId, CenterId FROM

        (
          SELECT ce.PersonId, sg.CenterId, 
            ROW_NUMBER() OVER (PARTITION BY ce.PersonId,sg.CenterId ORDER BY ce.EventNum ) AS ReverseOrder
          FROM dbo.ClinDataPoint cdp
          JOIN dbo.ClinEvent ce on ce.EventId = cdp.EventId
          JOIN dbo.StudyGroup sg ON sg.StudyId = ce.StudyId AND sg.GroupId = ce.GroupId
          WHERE cdp.ItemId = 1502 and cdp.EnumVal = 1 AND ce.EventTime < WeekList.StartTime
        ) LastCenter 

        WHERE LastCenter.ReverseOrder = 1
      ) pas

     JOIN

     (
       SELECT PersonId, COUNT(*) AS n 
       FROM dbo.LabData ld
       JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
       WHERE lc.LabClassId = 1084 AND ld.LabDate < WeekList.StartTime
       GROUP BY ld.PersonId 
     ) LabCount 

     ON labCount.PersonId = pas.PersonId

     GROUP BY pas.CenterId 
    ) PatientLabCount
   ) AggByCenter
  ) Dataset
  CROSS JOIN Report.DataSource() AS DataSource
  ORDER BY TimeAxis DESC;
END
GO

GRANT EXECUTE ON [Dash].[DiaBiobankAccumulated] TO [FastTrak]
GO