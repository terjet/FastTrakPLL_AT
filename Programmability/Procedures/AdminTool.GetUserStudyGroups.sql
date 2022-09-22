SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetUserStudyGroups](@UserId INT) AS
BEGIN
	SELECT
		s.StudyId,
	    s.StudName AS StudyName,
		su.UserId,
		sg.GroupId,
	    sg.GroupName
	FROM dbo.Study s
	LEFT JOIN dbo.StudyUser su ON su.StudyId = s.StudyId AND su.UserId = @UserId
	LEFT JOIN dbo.StudyGroup sg ON s.StudyId = sg.StudyId AND su.GroupId = sg.GroupId AND sg.DisabledAt IS NULL
	ORDER BY s.StudyId
END;
GO