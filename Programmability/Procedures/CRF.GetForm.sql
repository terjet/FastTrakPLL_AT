SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetForm]( @FormId INT ) AS
BEGIN 
  SELECT msf.StudyId,mf.FormId,mf.FormName,mf.FormTitle,mf.Subtitle,
    mf.CalculateInvalid, mf.RatingScale, mf.Copyright,
    mf.ThreadTypeId, mf.Instructions, 
    ISNULL(msf.Repeatable,mf.Repeatable) as Repeatable,
    ISNULL(msf.SurveyStatus,mf.SurveyStatus) AS SurveyStatus, 
    ISNULL(msf.FormActive,mf.FormActive ) AS FormActive,
    msf.HideComment,
    msf.ParentId, msf.CreatedAt,msf.CreatedBy           
    FROM dbo.MetaForm mf 
    JOIN dbo.MetaStudyForm msf ON msf.FormId=mf.FormId
    WHERE mf.FormId=@FormId;
END
GO