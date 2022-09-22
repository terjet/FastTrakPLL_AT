SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetStudyGroups] ( @StudyId INT, @CenterId INT, @ExcludeDisabled BIT = 1 ) AS
BEGIN
  SELECT StudyId, GroupId, GroupName, CenterId, StudyGroupId, GroupActive, BedCount, DisabledAt, DisabledBy
  FROM dbo.StudyGroup
  WHERE StudyId = @StudyId AND CenterId = @CenterId
  AND ( DisabledBy IS NULL OR @ExcludeDisabled = 0 );
END;
GO