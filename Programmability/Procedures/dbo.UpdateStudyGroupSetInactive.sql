SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateStudyGroupSetInactive]( @StudyGroupId INT ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.StudyGroup SET GroupActive = 0
  WHERE StudyGroupId = @StudyGroupId;
END
GO

GRANT EXECUTE ON [dbo].[UpdateStudyGroupSetInactive] TO [superuser]
GO