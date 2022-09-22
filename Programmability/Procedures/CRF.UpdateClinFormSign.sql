SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[UpdateClinFormSign]( @ClinFormId INT, @FormComment VARCHAR(MAX), @FormComplete TINYINT, @SessId INT = NULL ) AS
BEGIN
  DECLARE @StudyId INT;
  DECLARE @PersonId INT;
  DECLARE @EventId INT;
  DECLARE @OldFormStatus CHAR(1);
  DECLARE @OldFormComplete TINYINT;
  DECLARE @FormTitle VARCHAR(128);

  SET NOCOUNT ON;

  -- Get current status details about person/study
  SELECT @StudyId = ce.StudyId, @PersonId = ce.PersonId, @EventId = ce.EventId, @OldFormStatus = cf.FormStatus, @OldFormComplete = cf.FormComplete, @FormTitle = mf.FormTitle
  FROM dbo.ClinForm cf
  JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
  WHERE ClinFormId = @ClinFormId;

  -- Check for signed forms
  IF (@OldFormStatus = 'L')
  BEGIN
    RAISERROR ('%s er signert og kan ikke endres.', 16, 1, @FormTitle);
    RETURN -2;
  END
  ELSE
  BEGIN
    BEGIN
      -- Check form signing privileges for profession 
      IF dbo.HasSignClinFormPrivilege(@ClinFormId, NULL) <> 1
      BEGIN
        RAISERROR ('Du har ikke rettigheter til å signere %s!', 16, 1, @FormTitle);
        RETURN -1;
      END;
      EXEC CRF.UpdateClinFormSignItems @ClinFormId;
    END;

    -- Update form properties
    UPDATE dbo.ClinForm SET FormComplete = @FormComplete, FormStatus = 'L', Comment = @FormComment, SignedAt = GETDATE(), SignedBy = USER_ID(), SignedSessId = @SessId
    WHERE ClinFormId = @ClinFormId;

    -- Update StudCase with LastWrite
    UPDATE dbo.StudCase SET LastWrite = GETDATE()
    WHERE StudyId = @StudyId AND PersonId = @PersonId;

  END;
END
GO

GRANT EXECUTE ON [CRF].[UpdateClinFormSign] TO [FastTrak]
GO