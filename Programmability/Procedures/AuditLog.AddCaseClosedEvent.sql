SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AuditLog].[AddCaseClosedEvent]( @EventGuid uniqueidentifier ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE AuditLog.CaseAccess SET ClosedAt = GETDATE(), ClosedBy = USER_ID() WHERE EventGuid = @EventGuid;
END
GO