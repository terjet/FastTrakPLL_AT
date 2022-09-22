SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[MyStudyCenters]
AS
  SELECT DISTINCT uca.CenterId, sc.CenterName
    FROM dbo.UserCenterAccess uca
    JOIN dbo.StudyCenter sc ON sc.CenterId = uca.CenterId
    WHERE uca.UserId = USER_ID() AND ( uca.StartAt < GETDATE() ) AND ( uca.StopAt IS NULL OR uca.StopAt > GETDATE() )
  UNION 
  -- Include current center, but all centers if no center is set, or member of certain roles.
  SELECT sc.CenterId, sc.CenterName 
    FROM dbo.StudyCenter  sc
    JOIN dbo.UserList ul ON ISNULL( ul.CenterId, sc.CenterId ) = sc.CenterId 
      OR ( IS_MEMBER('ChangeWorksite')=1 OR IS_MEMBER('db_owner') = 1 )
    WHERE ul.UserId = USER_ID()
GO

GRANT SELECT ON [dbo].[MyStudyCenters] TO [FastTrak]
GO