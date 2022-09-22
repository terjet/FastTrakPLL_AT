SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetStudyAnswers]( @StudyId INT ) AS
BEGIN
  SELECT mia.ItemId, mia.OrderNumber, mia.AnswerId, mia.OptionText, 
    mia.VerboseText, mia.ICD10, mia.Score, mia.ShortCode, mia.LastUpdate,
    mia.HtmlColor, mia.IsDefaultAnswer
  FROM dbo.MetaItemAnswer mia
  WHERE ItemId IN 
    (
    SELECT DISTINCT ItemId FROM dbo.MetaFormItem mfi
    JOIN dbo.MetaStudyForm ms ON ms.FormId=mfi.FormId
    WHERE ms.StudyId=@StudyId
    )
   ORDER BY mia.ItemId,mia.OrderNumber;
END
GO