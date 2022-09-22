SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DbFinalizeUpgrade] (@DbVer INT) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.DbUpgradeLog
  SET DbUpgradeEnd = GETDATE()
  WHERE DbVer = @DbVer;
  IF dbo.DbVersion() = @DbVer
    PRINT CHAR(13) + 'Upgrade to ' + CONVERT(VARCHAR, @DbVer) + ' was successful.'
  ELSE
    PRINT CHAR(13) + 'Upgrade was NOT successful, database version is ' + CONVERT(VARCHAR, dbo.DbVersion()) + '.'
END
GO

GRANT EXECUTE ON [dbo].[DbFinalizeUpgrade] TO [Administrator]
GO