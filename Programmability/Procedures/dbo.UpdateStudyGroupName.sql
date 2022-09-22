SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateStudyGroupName]( @StudyGroupId INT, @GroupName VARCHAR(24) ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.StudyGroup SET GroupName = @GroupName
  WHERE StudyGroupId = @StudyGroupId;
END
GO

GRANT EXECUTE ON [dbo].[UpdateStudyGroupName] TO [superuser]
GO