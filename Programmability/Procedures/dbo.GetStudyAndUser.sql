SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetStudyAndUser]( @StudyName VARCHAR(40) ) AS
BEGIN
  SET XACT_ABORT ON;
  EXEC dbo.VerifyPersonalUser;
  EXEC dbo.VerifyStudyName @StudyName;
  -- Return details about user and study
  SELECT USER_ID() AS UserId, USER_NAME() AS UserName,
    s.*, p.*, mp.*, c.*, sg.*,
    su.ShowMyGroup, su.CaseList,
    IS_MEMBER('db_owner') AS IsDbOwner,
    IS_MEMBER('FMUser') AS IsFMUser,
    IS_MEMBER('Superuser') AS IsSuperuser,
    IS_MEMBER('SingleGroup') AS IsSingleGroupUser,
      ( SELECT COUNT(mr.RelId) FROM dbo.MetaRelation mr WHERE mr.ProfType = mp.ProfType AND mr.DisabledAt IS NULL ) AS RelationCount
  FROM dbo.Study s
  LEFT JOIN dbo.UserList ul ON ul.UserId = USER_ID()
  LEFT JOIN dbo.Person p ON p.PersonId = ul.PersonId
  LEFT JOIN dbo.StudyCenter c ON c.CenterId = ul.CenterId
  LEFT JOIN dbo.StudyUser su ON su.UserId = ul.UserId AND su.StudyId = s.StudyId
  LEFT JOIN dbo.StudyGroup sg ON sg.GroupId = su.GroupId AND sg.StudyId = s.StudyId
  LEFT JOIN dbo.MetaProfession mp ON mp.ProfId = ul.ProfId
  WHERE s.StudyName = @StudyName;
END
GO