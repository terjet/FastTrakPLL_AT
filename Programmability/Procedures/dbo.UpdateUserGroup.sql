SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateUserGroup]( @StudyId INT, @UserId INT, @GroupId INT ) AS
BEGIN
  SET NOCOUNT ON;
  IF NOT EXISTS( SELECT 1 FROM dbo.StudyUser WHERE UserId = @UserId AND StudyId = @StudyId )
    INSERT INTO dbo.StudyUser( StudyId, UserId, GroupId ) 
	VALUES( @StudyId, @UserId, @GroupId );
  ELSE
    UPDATE dbo.StudyUser SET GroupId = @GroupId 
	WHERE StudyId = @StudyId AND UserId = @UserId;
END
GO

DENY EXECUTE ON [dbo].[UpdateUserGroup] TO [ReadOnly]
GO

GRANT EXECUTE ON [dbo].[UpdateUserGroup] TO [Support]
GO