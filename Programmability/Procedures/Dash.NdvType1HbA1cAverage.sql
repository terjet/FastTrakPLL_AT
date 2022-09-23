SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[NdvType1HbA1cAverage] AS
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
      Agg.MinHbA1c,
      Agg.AvgHbA1c, 
      Agg.MaxHbA1c
    FROM
  
    (
      SELECT StartTime FROM Report.TimePeriods ml 
      WHERE PeriodType = 'MONTH' AND StartTime > DATEADD( YEAR, -5, GETDATE() ) AND StartTime < GETDATE()
    ) MonthList
  
  CROSS APPLY
  
    (
      SELECT COUNT(Type1.NumResult) AS NumHbA1c,
        MIN(Type1.NumResult) AS MinHbA1c,
        MAX(Type1.NumResult) AS MaxHbA1c,
        AVG(Type1.NumResult) AS AvgHbA1c
      FROM
      (
        SELECT cas.PersonId,lab.NumResult
        FROM NDV.GetRecentPatientsTable( 1, MonthList.StartTime, 15 ) cas
        JOIN dbo.GetLastLabDataTable( 1058, MonthList.StartTime) lab ON lab.PersonId = cas.PersonId
      ) Type1
    ) Agg
  
  CROSS APPLY 
  
    (
      SELECT COUNT(*) AS NumPatients FROM NDV.GetRecentPatientsTable( 1, MonthList.StartTime, 15 )
    ) AllType1
    WHERE AllType1.NumPatients > 0
  )  Dataset
  
  CROSS JOIN Report.DataSource() AS DataSource
  
  JOIN dbo.UserList ul ON ul.UserId = USER_ID()
  
  ORDER BY TimeAxis DESC;

END;
GO

GRANT EXECUTE ON [Dash].[NdvType1HbA1cAverage] TO [FastTrak]
GO