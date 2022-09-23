SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[NdvType1HbA1cAbove9] AS
BEGIN

  SELECT
  
    Report.PartitionKey( ul.CenterId ) AS PartitionKey,
    Report.RowKeyReverse( Dataset.TimeAxis ) AS RowKey,
    'MM' AS TimeResolution,
    Dataset.*,
    DataSource.*
  
    FROM
  
  ( SELECT
      MonthList.StartTime AS TimeAxis, 
      AllType1.NumPatients,
      AboveCutoffAgg.NumHbA1c AS NumAboveCutoff, 
      AboveCutoffAgg.MinHbA1c,
      AboveCutoffAgg.AvgHbA1cAboveCutoff, 
      AboveCutoffAgg.MaxHbA1c,
      100.0 * AboveCutoffAgg.NumHbA1c / AllType1.NumPatients AS PctAboveCutoffTotal
    FROM
  
    (
      SELECT StartTime FROM Report.TimePeriods ml 
      WHERE PeriodType = 'MONTH' AND StartTime > DATEADD( YY, -5, GETDATE() ) AND StartTime < GETDATE()
    ) MonthList
  
  CROSS APPLY
  
    (
      SELECT COUNT(Type1AboveCutoff.NumResult) AS NumHbA1c,
        MIN(Type1AboveCutoff.NumResult) AS MinHbA1c,
        MAX(Type1AboveCutoff.NumResult) AS MaxHbA1c,
        AVG(Type1AboveCutoff.NumResult) AS AvgHbA1cAboveCutoff
      FROM
      (
        SELECT cas.PersonId,lab.NumResult
        FROM NDV.GetRecentPatientsTable( 1, MonthList.StartTime, 15 ) cas
        JOIN dbo.GetLastLabDataTable( 1058, MonthList.StartTime) lab ON lab.PersonId = cas.PersonId
  	  WHERE NumResult >= 75
      ) Type1AboveCutoff
    ) AboveCutoffAgg
  
  CROSS APPLY 
  
    (
      SELECT COUNT(*) AS NumPatients FROM NDV.GetRecentPatientsTable( 1, MonthList.StartTime, 15 )
    ) AllType1
    WHERE AllType1.NumPatients > 0
  )  Dataset
  
  CROSS JOIN Report.DataSource() AS DataSource
  
  JOIN dbo.UserList ul ON ul.UserId = USER_ID()
  
  ORDER BY TimeAxis DESC
END;
GO

GRANT EXECUTE ON [Dash].[NdvType1HbA1cAbove9] TO [FastTrak]
GO