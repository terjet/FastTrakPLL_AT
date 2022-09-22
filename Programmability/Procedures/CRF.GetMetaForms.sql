SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetMetaForms]( @StudyId INT ) AS
BEGIN
  SELECT msf.StudyId, mf.FormId, mf.FormName, msf.FormTitle, mf.Subtitle,
    mf.CalculateInvalid, mf.RatingScale, mf.Copyright, msf.HideComment,
    mf.ThreadTypeId, mf.Instructions,
    ISNULL(msf.Repeatable, mf.Repeatable) AS Repeatable,
    ISNULL(msf.SurveyStatus, mf.SurveyStatus) AS SurveyStatus,
    ISNULL(msf.FormActive, mf.FormActive) AS FormActive,
    msf.ParentId, msf.CreatedAt, msf.CreatedBy
  FROM dbo.MetaForm mf
  JOIN dbo.MetaStudyForm msf ON msf.FormId = mf.FormId
  WHERE msf.StudyId=@StudyId;
END
GO

GRANT EXECUTE ON [CRF].[GetMetaForms] TO [FastTrak]
GO