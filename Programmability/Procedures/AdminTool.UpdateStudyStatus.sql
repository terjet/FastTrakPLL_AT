SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[UpdateStudyStatus] (@StudyId INT, @StatusId INT, @StatusActive INT) AS
BEGIN
    UPDATE dbo.StudyStatus
    SET StatusActive = @StatusActive
    WHERE StudyId = @StudyId
    AND StatusId = @StatusId;
END;
GO