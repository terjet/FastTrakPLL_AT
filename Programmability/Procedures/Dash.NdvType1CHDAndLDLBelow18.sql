SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[NdvType1CHDAndLDLBelow18] AS
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
      AggregatedData.NumPatients,
      AggregatedData.GoalReachedCount AS NumBelowCutoff, 
      100.0 * AggregatedData.GoalReachedCount / AggregatedData.NumPatients AS PctBelowCutoffTotal 
    FROM
  
    (
      SELECT StartTime 
      FROM Report.TimePeriods ml 
      WHERE PeriodType = 'MONTH' AND StartTime > DATEADD( YY, -2, GETDATE() ) AND StartTime < GETDATE()
    ) MonthList
  
  CROSS APPLY
  
    (
      SELECT COUNT( Type1Patients.PersonId ) AS NumPatients,
        SUM( Type1Patients.GoalReached ) AS GoalReachedCount
      FROM
      (
        SELECT cas.PersonId,lab.NumResult, 
          CASE WHEN lab.NumResult < 1.8 THEN 1 ELSE 0 END AS GoalReached
        FROM NDV.GetRecentPatientsTable( 1, MonthList.StartTime, 15 ) cas
          JOIN dbo.Person p ON p.PersonId = cas.PersonId
          JOIN dbo.GetLastLabDataTable( 35, MonthList.StartTime ) lab ON lab.PersonId = cas.PersonId
          JOIN NDV.GetCvdTable( MonthList.StartTime ) v ON v.PersonId = cas.PersonId
        WHERE v.HasCVD = 1
      ) Type1Patients

    ) AggregatedData
  
  )  Dataset
  
  CROSS JOIN Report.DataSource() AS DataSource
  
  JOIN dbo.UserList ul ON ul.UserId = USER_ID()

  WHERE Dataset.NumPatients > 1  

  ORDER BY TimeAxis DESC;
  
END
GO

GRANT EXECUTE ON [Dash].[NdvType1CHDAndLDLBelow18] TO [FastTrak]
GO