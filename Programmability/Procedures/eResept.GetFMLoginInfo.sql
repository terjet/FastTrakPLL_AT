SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[GetFMLoginInfo] AS
BEGIN
  SELECT 
    COALESCE( ul.FMUserName, ul.UserName ) AS FmUserName, 
    COALESCE( ul.FMPassword, ul.FMUserName, ul.UserName ) AS FmPassword,
    c.*
  FROM dbo.UserList ul 
  LEFT JOIN dbo.StudyCenter c ON c.CenterId = ul.CenterId
  WHERE ul.UserId = USER_ID();
END
GO

GRANT EXECUTE ON [eResept].[GetFMLoginInfo] TO [FastTrak]
GO