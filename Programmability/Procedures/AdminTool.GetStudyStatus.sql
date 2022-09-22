SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetStudyStatus] ( @StudyId INT ) AS
BEGIN
    SELECT * FROM dbo.StudyStatus WHERE StudyId = @StudyId;
END;
GO