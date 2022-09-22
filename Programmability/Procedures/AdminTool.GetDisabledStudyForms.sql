SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetDisabledStudyForms]( @StudyId INT, @ActiveOnly BIT ) AS
BEGIN
    SELECT msf.StudyId,
        mf.FormId,
        mf.FormName,
        mf.FormTitle,
        mf.Subtitle,
        mf.SurveyStatus,
        msf.DisabledAt,
        ul.UserName AS DisabledByUserName
    FROM dbo.MetaForm mf
    JOIN dbo.MetaStudyForm msf ON msf.FormId = mf.FormId
    LEFT JOIN dbo.UserList ul ON ul.UserId = msf.DisabledBy
    WHERE msf.StudyId = @StudyId
    AND (ISNULL(mf.FormActive, 0) = 1 OR @ActiveOnly = 0);
END;
GO