SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetAlertsByPerson]( @StudyId INT, @PersonId INT, @MinLevel INT = 0 ) AS
BEGIN

  SET NOCOUNT ON;
  DECLARE @BlockRules BIT;                            

  IF dbo.FnDSSRulesAreDirty( @StudyId, @PersonId ) = 1
    EXEC dbo.UpdateDSSAlerts @StudyId,@PersonId;

  SELECT @BlockRules = BlockRules 
    FROM dbo.StudyGroup sg 
    JOIN dbo.StudCase sc ON sc.GroupId=sg.GroupId AND sc.StudyId=@StudyId AND sc.PersonId=@PersonId
    JOIN dbo.StudyCenter c ON c.CenterId=sg.CenterId;

  SELECT a.AlertId, a.AlertClass, a.AlertHeader, a.AlertMessage, a.AlertFacet, a.AlertLevel, a.HideUntil, a.AlertButtons, a.CreatedAt, a.CreatedBy, up.signature AS CreatedBySign 
  FROM dbo.Alert a
    JOIN dbo.UserList ul ON ul.UserId = a.CreatedBy
    LEFT OUTER JOIN dbo.Person up ON up.PersonId = ul.PersonId
    WHERE ( (StudyId=@StudyId ) OR ( StudyId IS NULL ) ) AND (  a.PersonId=@PersonId ) AND ( AlertLevel>=@MinLevel )
      AND ((@MinLevel = 0 ) OR (ISNULL(HideUntil,GetDate()-1)<GetDate() )) AND ( NOT @BlockRules = 1 )
    ORDER BY AlertLevel DESC;

END
GO