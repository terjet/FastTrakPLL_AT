SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[DisableFMForPatient] @PersonId INT AS
BEGIN
  BEGIN TRANSACTION;
  BEGIN TRY
    UPDATE dbo.Person SET FMEnabled = 0 WHERE PersonId = @PersonId;
    UPDATE dbo.DrugTreatment SET FMLibId = NULL  WHERE PersonId = @PersonId AND NOT FMLibId IS NULL;
    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    DECLARE @ErrMsg VARCHAR(512);
    SET @ErrMsg = CONCAT(  'Kunne ikke slå av FM for denne pasienten', ERROR_MESSAGE() );
    RAISERROR ( @ErrMsg , 16, 1 );
  END CATCH;
END
GO

GRANT EXECUTE ON [eResept].[DisableFMForPatient] TO [Support]
GO