SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AuditLog].[AddCaseOpenedEvent]( @EventGuid uniqueidentifier, @PersonId INT, @ClinRelId INT, @AccessText VARCHAR(MAX) = NULL ) AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO AuditLog.CaseAccess ( EventGuid, PersonId, AccessTypeId, AccessText, ClinRelId ) VALUES ( @EventGuid, @PersonId, 1, @AccessText, NULLIF(@ClinRelId,0) )
END
GO

GRANT EXECUTE ON [AuditLog].[AddCaseOpenedEvent] TO [FastTrak]
GO