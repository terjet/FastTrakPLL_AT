SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetCenterStudyGroups](@CenterId INT, @ExcludeDisabled BIT) AS
BEGIN
	SELECT *
	FROM dbo.StudyGroup sg
	WHERE sg.CenterId = @CenterId
	AND (sg.DisabledAt IS NULL OR @ExcludeDisabled = 0);
END;
GO