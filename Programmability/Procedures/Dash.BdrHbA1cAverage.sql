SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[BdrHbA1cAverage] AS
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
      RecentStablePatients.NumPatients,
      Agg.MinHbA1c,
      Agg.AvgHbA1c, 
      Agg.MaxHbA1c
    FROM
  
    (
      SELECT StartTime FROM Report.TimePeriods ml 
      WHERE PeriodType = 'MONTH' AND StartTime > DATEADD( YEAR, -3, GETDATE() ) AND StartTime < GETDATE()
    ) MonthList
  
  CROSS APPLY
  
    (
      SELECT COUNT(RecentStablePatients.NumResult) AS NumHbA1c,
        MIN(RecentStablePatients.NumResult) AS MinHbA1c,
        MAX(RecentStablePatients.NumResult) AS MaxHbA1c,
        AVG(RecentStablePatients.NumResult) AS AvgHbA1c
      FROM
      (
        SELECT cas.PersonId,lab.NumResult
        FROM BDR.GetRecentStablePatientsTable(MonthList.StartTime, 6, 6) cas
        JOIN dbo.GetLastLabDataTable( 1058, MonthList.StartTime) lab ON lab.PersonId = cas.PersonId
      ) RecentStablePatients
    ) Agg
  
  CROSS APPLY 
  
    (
      SELECT COUNT(*) AS NumPatients FROM BDR.GetRecentStablePatientsTable(MonthList.StartTime, 6, 6)
    ) RecentStablePatients
    WHERE RecentStablePatients.NumPatients > 5
  )  Dataset
  
  CROSS JOIN Report.DataSource() AS DataSource
  
  JOIN dbo.UserList ul ON ul.UserId = USER_ID()
  
  ORDER BY TimeAxis DESC;
END;
GO

GRANT EXECUTE ON [Dash].[BdrHbA1cAverage] TO [FastTrak]
GO