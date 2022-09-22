SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DbDowngrade]
AS
BEGIN 
  DECLARE @DbVer INT;
  SELECT @DbVer=Max(DbVer) FROM DbUpgradeLog WHERE NOT DbUpgradeEnd IS NULL AND DbVer > 460;
  IF @DbVer IS NULL
    RAISERROR ('Databasen kan ikke nedgraderes ytterligere',16,1)
  ELSE BEGIN
    UPDATE DbUpgradeLog SET DbUpgradeEnd = NULL WHERE DbVer=@DbVer;
    SELECT @DbVer=Max(DbVer) FROM DbUpgradeLog WHERE NOT DbUpgradeEnd IS NULL;
    RAISERROR( 'Databasen er nedgradert til versjon %d', 16,1,@DbVer );
  END 
END
GO

GRANT EXECUTE ON [dbo].[DbDowngrade] TO [superuser]
GO