SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Test].[RegretFmActivation]( @PersonId INT, @ResetProfilId BIT = 0 ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.Person SET FmEnabled = 0 WHERE PersonId = @PersonId;
  -- Reset ProfilId
  IF @ResetProfilId = 1 
    UPDATE dbo.Person SET  FstName = CONCAT( 'Testperson ', FmPatientId), MidName=NULL, LstName = 'Profil', FMPatientId = NULL 
    WHERE PersonId = @PersonId;
  UPDATE dbo.DrugReaction SET DeletedAt = NULL, DeletedBy = NULL WHERE PersonId = @PersonId;
  UPDATE dbo.DrugTreatment SET StopAt = NULL, StopBy = NULL WHERE PersonId = @PersonId AND StopReason IN ( 'FM aktivert' )
  BEGIN TRY
    DELETE FROM dbo.DrugTreatment WHERE PersonId = @PersonId AND ( NOT FMLibId IS NULL OR StopReason = 'Seponert i FM' OR Seponeringskladd = 1 OR Forskrivningskladd = 1 );
    DELETE FROM dbo.DrugReaction WHERE PersonId = @PersonId AND NOT ( CaveId IS NULL );
  END TRY
  BEGIN CATCH
    PRINT ERROR_MESSAGE();
    RETURN -1;
  END CATCH;
END;
GO