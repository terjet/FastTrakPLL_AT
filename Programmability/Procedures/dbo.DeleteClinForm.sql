SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteClinForm](@ClinFormId INT)
AS
BEGIN
  IF ( IS_MEMBER('db_owner') = 1 )  OR ( IS_MEMBER('Journalansvarlig') = 1 )
    EXEC CRF.DeleteClinForm @ClinFormId
  ELSE
    EXEC CRF.DeleteMyClinForm @ClinFormId;
END
GO

GRANT EXECUTE ON [dbo].[DeleteClinForm] TO [FastTrak]
GO