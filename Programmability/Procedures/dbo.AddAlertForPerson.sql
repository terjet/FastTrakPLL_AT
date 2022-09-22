SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddAlertForPerson]( @StudyId INT, @PersonId INT, @AlertLevel INT, @AlertClass varchar(12),
 @AlertFacet varchar(16), @AlertHeader varchar(64), @AlertMessage varchar(512), @AlertButtons VARCHAR(6) = 'TMYF' )
AS
BEGIN
  DECLARE @AlertId INT;
  DECLARE @OldFacet varchar(16);
  /* Look for latest non-private alert of this class for PersonId */
  SELECT @AlertId = MAX(AlertId) FROM Alert
    WHERE ISNULL(StudyId,0)=ISNULL(@StudyId,0) AND ( PersonId=@PersonId )
    AND ( ISNULL(UserId,0)=0 ) AND (AlertClass=@AlertClass);
  IF @AlertId IS NULL
    /* No alert of this class ever */
    INSERT INTO Alert (StudyId,PersonId,AlertLevel,AlertClass,AlertFacet,AlertHeader,AlertMessage,AlertButtons)
       VALUES ( @StudyId,@PersonId,@AlertLevel,@AlertClass,@AlertFacet,@AlertHeader,@AlertMessage,@AlertButtons)
  ELSE BEGIN
    /* Update alert if different alert facet */
    SELECT @OldFacet = AlertFacet FROM Alert WHERE AlertId=@AlertId;
    UPDATE Alert SET AlertLevel=@AlertLevel,AlertHeader=@AlertHeader,
      AlertMessage=@AlertMessage,AlertButtons=@AlertButtons,
      AlertFacet=@AlertFacet WHERE AlertId=@AlertId;
    IF ( @OldFacet <> @AlertFacet) UPDATE Alert SET HideUntil=NULL WHERE AlertId=@AlertId;
  END
END
GO

GRANT EXECUTE ON [dbo].[AddAlertForPerson] TO [FastTrak]
GO