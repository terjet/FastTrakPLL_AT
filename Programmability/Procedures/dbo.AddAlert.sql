SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddAlert]( @StudyId INT, @PersonId INT, @AlertLevel INT, @AlertClass VARCHAR(12),
 @AlertFacet varchar(16), @AlertHeader VARCHAR(64), @AlertMessage VARCHAR(512), @HideUntil DATETIME ) AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO dbo.Alert (StudyId,PersonId,AlertLevel,AlertClass,AlertFacet,AlertHeader,AlertMessage,HideUntil,AlertButtons)
    VALUES ( @StudyId,@PersonId,@AlertLevel,@AlertClass,@AlertFacet,@AlertHeader,@AlertMessage,@HideUntil,'*');
  SELECT a.AlertId, a.CreatedAt, a.CreatedBy, up.signature AS CreatedBySign
  FROM dbo.Alert a 
  JOIN dbo.UserList ul ON ul.UserId = a.CreatedBy
  LEFT OUTER JOIN dbo.Person up ON up.PersonId = ul.PersonId
  WHERE a.AlertId = SCOPE_IDENTITY();
END
GO