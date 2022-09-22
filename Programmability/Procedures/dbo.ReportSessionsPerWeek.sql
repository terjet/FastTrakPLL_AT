SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportSessionsPerWeek]( @CenterId INT = 0 )
AS
BEGIN
  SELECT ServYear,ServWeek,count(*) AS SessCount FROM dbo.UserLog lg
  JOIN dbo.UserList usr ON lg.UserId=usr.UserId
  WHERE ( usr.CenterId=@CenterId ) OR ( @CenterId=0)
  GROUP BY ServYear,ServWeek
  ORDER BY ServYear,ServWeek
END
GO