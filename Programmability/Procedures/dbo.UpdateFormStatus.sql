SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateFormStatus]( @EventId INT, @FormId INT, @FormStatus CHAR(1), @FormComplete TINYINT )
AS
BEGIN
  DECLARE @StudyId INT;
  DECLARE @PersonId INT;
  DECLARE @ClinFormId INT;
  DECLARE @OldFormStatus CHAR(1);
  DECLARE @OldFormComplete TINYINT;
  SELECT @ClinFormId = ClinFormId, @OldFormStatus = FormStatus, @OldFormComplete = FormComplete
    FROM ClinForm WHERE EventId=@EventId AND FormId=@FormId;
  IF ( @FormStatus <> @OldFormStatus ) OR ( @FormComplete<>@OldFormComplete )
  BEGIN
    /* perform updates */
    IF @OldFormComplete <> @FormComplete UPDATE ClinForm SET FormComplete = @FormComplete WHERE ClinFormId=@ClinFormId;
    IF ( @OldFormStatus = 'L' ) AND ( @FormStatus <>'L' )
      RAISERROR ('Skjemaet signert og kan ikke endre status', 16, 1 )
    ELSE IF ( @OldFormStatus <> @FormStatus ) 
    BEGIN
      IF @FormStatus='L' 
        EXEC UpdateFormSignClinId @ClinFormId
      ELSE
        UPDATE ClinForm SET FormStatus=@FormStatus WHERE ClinFormId=@ClinFormId;
    END;
    /* Find study and person, needed to update StudCase */
    SELECT @StudyId=StudyId,@PersonId=PersonId FROM ClinEvent WHERE EventId=@EventId;
    UPDATE StudCase SET LastWrite = getdate() WHERE StudyId=@StudyId AND PersonId=@PersonId;
  END;
END
GO