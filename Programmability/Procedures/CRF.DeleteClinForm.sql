SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[DeleteClinForm]( @ClinFormId INT ) AS
BEGIN
  SET NOCOUNT ON;
  -- Mark form as deleted
  UPDATE dbo.ClinForm SET DeletedAt = GETDATE(), DeletedBy = USER_ID()
  WHERE (ClinFormId = @ClinFormId)
  AND (SignedBy IS NULL)
  AND (DeletedBy IS NULL);
  -- Check result
  IF @@rowcount = 0
  BEGIN
    RAISERROR ('Du kan bare slette usignerte skjema!', 16, 1);
    RETURN -1;
  END;
  -- If successful, delete form items
  EXEC CRF.DeleteClinFormItems @ClinFormId;
  -- If the form has subforms, delete them
  IF EXISTS (SELECT 1 FROM CRF.ClinThreadForm ctf WHERE ctf.ClinFormId = @ClinFormId)
  BEGIN
    EXEC CRF.DeleteClinThreadForms @ClinFormId
  END
END
GO

GRANT EXECUTE ON [CRF].[DeleteClinForm] TO [Journalansvarlig]
GO