SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DbStartUpgrade] (@ExpectedVersion INT, @TargetVersion INT, @IsRepeatable BIT = 1) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @InfoText VARCHAR(65);
  SET @InfoText = CONVERT(VARCHAR, @TargetVersion) + ' for ' + DB_NAME() + ' on ' + @@servername + '.' + CHAR(13);
  IF @IsRepeatable = 1
    DELETE FROM DbUpgradeLog
    WHERE DbVer > @TargetVersion;
  DECLARE @RetVal INT;
  IF dbo.DbVersion() = @TargetVersion
  BEGIN
    PRINT 'Reapplying database upgrade ' + @InfoText;
    UPDATE dbo.DbUpgradeLog
    SET DbUpgradeStart = GETDATE(), DbUpgradeEnd = NULL, UpgradedBy = USER_ID()
    WHERE DbVer = @TargetVersion;
    SET @RetVal = 1;
  END
  ELSE
  IF dbo.DbVersion() = @ExpectedVersion
  BEGIN
    INSERT INTO dbo.DbUpgradeLog (DbVer, DbUpgradeStart)
      VALUES (@TargetVersion, GETDATE());
    PRINT 'Applying database upgrade ' + @InfoText;
    SET @RetVal = 2;
  END
  ELSE
  BEGIN
    PRINT 'Unexpected database version: ' + CONVERT(VARCHAR, dbo.DbVersion()) + '!'
    SET @RetVal = -1;
  END;
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[DbStartUpgrade] TO [Administrator]
GO