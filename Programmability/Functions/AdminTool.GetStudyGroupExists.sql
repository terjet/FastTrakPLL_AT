SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [AdminTool].[GetStudyGroupExists](@StudyId INT, @CenterId INT, @GroupName VARCHAR(24)) RETURNS BIT
BEGIN
	DECLARE @GroupId BIT;
	SELECT @GroupId = GroupId FROM dbo.StudyGroup sg WHERE sg.StudyId = @StudyId AND sg.GroupName = @GroupName AND sg.CenterId = @CenterId;
	RETURN IIF(@GroupId IS NOT NULL, 1, 0);
END;
GO