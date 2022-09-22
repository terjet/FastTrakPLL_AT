SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateStudyGroupBedCount]( @StudyGroupId INT, @BedCount INT ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.StudyGroup SET BedCount = @BedCount
  WHERE StudyGroupId = @StudyGroupId;
END
GO

GRANT EXECUTE ON [dbo].[UpdateStudyGroupBedCount] TO [superuser]
GO