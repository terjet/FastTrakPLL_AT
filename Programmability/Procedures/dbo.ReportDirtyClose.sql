SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportDirtyClose] AS
BEGIN
  SELECT y, m, AppVer, Dirty, Total, Dirty*100/Total AS PercentDirty FROM
  (
    SELECT ServYear AS y, ServMonth AS m, AppVer,
    SUM(CASE WHEN DirtyClose = 1 OR ClosedAt IS NULL THEN 1 ELSE 0 END ) AS Dirty,
    COUNT(*) AS Total
    FROM dbo.UserLog
    WHERE AppVer LIKE '[3-9].[0-9]%'
    GROUP BY ServYear, ServMonth, AppVer
  ) a 
  ORDER BY y DESC, m DESC, AppVer DESC
END
GO

GRANT EXECUTE ON [dbo].[ReportDirtyClose] TO [FastTrak]
GO