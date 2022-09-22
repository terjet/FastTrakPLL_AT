SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportSessionsPerDay] AS
BEGIN
  SELECT ServYear,ServMonth,count(*) as SessCount FROM UserLog
  GROUP BY ServYear,ServMonth
  ORDER BY ServYear,ServMonth
END
GO