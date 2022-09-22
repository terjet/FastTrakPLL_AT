SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateStudyGroupSetActive]( @StudyGroupId INT ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.StudyGroup SET GroupActive = 1
  WHERE StudyGroupId = @StudyGroupId;
END
GO

GRANT EXECUTE ON [dbo].[UpdateStudyGroupSetActive] TO [superuser]
GO