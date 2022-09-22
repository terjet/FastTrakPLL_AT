SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDatabaseInfo] AS
BEGIN
  SET DATEFORMAT YMD;
  SELECT user_id() AS UserId,user_name() AS UserName,DB_NAME() as DatabaseName,
    Max(dbVer) AS DatabaseVersion,1 as ServerType,getdate() as ServerTime, @@VERSION as ServerVersion, 
    24 as EventScale,dbo.FnEventNumToDate(0) as NullDateTime
    FROM DbUpgradeLog WHERE NOT DbUpgradeEnd IS NULL;
END
GO

GRANT EXECUTE ON [dbo].[GetDatabaseInfo] TO [FastTrak]
GO