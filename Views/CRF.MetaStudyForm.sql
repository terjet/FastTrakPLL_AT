SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [CRF].[MetaStudyForm] AS
    SELECT msf.StudyId, mf.FormId, mf.FormName, 
            ISNULL( msf.FormTitle, mf.FormTitle) AS FormTitle,  
            mf.Subtitle,
        mf.CalculateInvalid, mf.RatingScale, mf.Copyright, msf.HideComment,
        mf.ThreadTypeId, mf.Instructions, 
                mf.FormDateItemId, mfi.ItemText, mfi.ItemHeader, mfi.ItemHelp,
        ISNULL(msf.Repeatable, mf.Repeatable) AS Repeatable,
        ISNULL(msf.SurveyStatus, mf.SurveyStatus) AS SurveyStatus,
        ISNULL(msf.FormActive, mf.FormActive) AS FormActive,
        msf.ParentId, msf.CreatedAt, msf.CreatedBy
    FROM dbo.MetaForm mf
    JOIN dbo.MetaStudyForm msf ON msf.FormId = mf.FormId
        LEFT JOIN dbo.MetaFormItem mfi ON mfi.FormId = mf.FormId AND mfi.ItemId = mf.FormDateItemId
    WHERE msf.DisabledAt IS NULL;
GO