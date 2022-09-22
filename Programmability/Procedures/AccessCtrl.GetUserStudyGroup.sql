SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AccessCtrl].[GetUserStudyGroup]( @StudyId INT, @UserId INT )AS
BEGIN
  SELECT sg.*
  FROM dbo.Study s
  JOIN dbo.StudyUser su ON su.StudyId = s.StudyId AND su.UserId = @UserId
  JOIN dbo.StudyGroup sg ON s.StudyId = sg.StudyId AND su.GroupId = sg.GroupId
  WHERE s.StudyId = @StudyId;
END;
GO