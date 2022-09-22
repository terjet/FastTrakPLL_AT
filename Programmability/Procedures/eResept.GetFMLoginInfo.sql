﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[GetFMLoginInfo] AS
BEGIN
  SELECT COALESCE( ul.FMUserName, ul.UserName ) AS FmUserName, COALESCE(ul.UserName, ul.FMUserName, ul.FMPassword ) AS FmPassword
  FROM dbo.UserList ul
  WHERE ul.UserId = USER_ID();
END
GO

GRANT EXECUTE ON [eResept].[GetFMLoginInfo] TO [FastTrak]
GO