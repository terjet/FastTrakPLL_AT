SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[UserListByTempSite] AS
BEGIN
  SELECT 
    subj.UserId, USER_NAME(subj.UserId) AS UserName, subjPrs.ReverseName AS GrantedTo, sc.CenterName, subjMp.ProfName, 
    uca.StartAt, uca.StopAt, uca.Comment, admPrs.ReverseName AS GrantedBy
  FROM dbo.Person AS admPrs 
    RIGHT OUTER JOIN dbo.MetaProfession AS subjMp 
    INNER JOIN dbo.UserCenterAccess AS uca 
    INNER JOIN dbo.UserList AS subj ON uca.UserId = subj.UserId 
    INNER JOIN dbo.StudyCenter AS sc ON uca.CenterId = sc.CenterId ON subjMp.ProfId = subj.ProfId 
    LEFT OUTER JOIN dbo.UserList AS administrator ON uca.GrantedBy = administrator.UserId ON admPrs.PersonId = administrator.PersonId 
    LEFT OUTER JOIN dbo.Person AS subjPrs ON subj.PersonId = subjPrs.PersonId
  ORDER BY sc.CenterName;
END
GO

GRANT EXECUTE ON [report].[UserListByTempSite] TO [Administrator]
GO

GRANT EXECUTE ON [report].[UserListByTempSite] TO [Avdelingsleder]
GO

GRANT EXECUTE ON [report].[UserListByTempSite] TO [Leder]
GO

GRANT EXECUTE ON [report].[UserListByTempSite] TO [Support]
GO