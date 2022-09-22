SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[DeleteMyClinForm]( @ClinFormId INT )
AS
BEGIN
  -- Mark form as deleted
  UPDATE dbo.ClinForm
  SET    DeletedAt = GETDATE(),DeletedBy = USER_ID()
  WHERE  ( ClinFormId = @ClinFormId ) AND ( CreatedBy = USER_ID() ) AND ( SignedBy IS NULL ) AND ( DeletedBy IS NULL );
  -- Check result
  IF @@ROWCOUNT = 0
    BEGIN
      RAISERROR( 'Du kan bare slette dine egne usignerte skjema!',16,1 );
      RETURN -1;
    END;
  -- If successful, delete form items
  EXEC CRF.DeleteClinFormItems @ClinFormId;
  -- If this form has subforms, delete them
  IF EXISTS (SELECT 1 FROM CRF.ClinThreadForm ctf WHERE ctf.ClinFormId = @ClinFormId)
  BEGIN
    EXEC CRF.DeleteClinThreadForms @ClinFormId
  END
END
GO