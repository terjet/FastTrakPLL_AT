SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[DirtyClose] AS
BEGIN

  DECLARE @StartOfThisWeek DateTime;
  SET @StartOfThisWeek = Report.StartOfWeek( GETDATE() );
  SELECT
  
    Report.PartitionKey( NULL ) AS PartitionKey,
    Report.RowKeyReverse( Dataset.TimeAxis ) AS RowKey,
    'WW' AS TimeResolution,
    Dataset.*,
      CONVERT(DECIMAL(5,1),DirtySessions * 100.0 / TotalSessions ) AS DirtyInPercent,
    DataSource.*
  
  FROM
  
    ( SELECT
        Report.StartOfWeek( MAX( ServTime) ) AS TimeAxis,
        COUNT(*) AS TotalSessions,
        SUM(CASE WHEN DirtyClose = 1 OR ClosedAt IS NULL THEN 1 ELSE 0 END ) AS DirtySessions
      FROM dbo.UserLog
      WHERE AppVer LIKE '[3-9].[0-9]%' AND ServTime <  @StartOfThisWeek
      GROUP BY ServYear, ServWeek
    ) Dataset
  
  CROSS JOIN Report.DataSource() AS DataSource
  ORDER BY TimeAxis DESC;
  
END;
GO

GRANT EXECUTE ON [Dash].[DirtyClose] TO [FastTrak]
GO