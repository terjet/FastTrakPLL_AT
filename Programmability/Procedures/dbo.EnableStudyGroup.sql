SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EnableStudyGroup]( @StudyGroupId INT ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.StudyGroup SET DisabledAt = NULL, DisabledBy = NULL
  WHERE StudyGroupId = @StudyGroupId;
END
GO

GRANT EXECUTE ON [dbo].[EnableStudyGroup] TO [superuser]
GO