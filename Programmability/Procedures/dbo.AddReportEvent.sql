SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddReportEvent] (@ReportName VARCHAR(MAX), @PersonId INT) AS
BEGIN
  SET NOCOUNT ON;
  IF @PersonId > 0
    INSERT INTO dbo.CaseLog (PersonId, LogType, LogText)
      VALUES (@PersonId, 'RAPPORT', 'Rapport "' + @ReportName + '" ble åpnet av ' + USER_NAME());
END
GO

GRANT EXECUTE ON [dbo].[AddReportEvent] TO [FastTrak]
GO