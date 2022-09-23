SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListStratify]( @StudyId INT ) AS
BEGIN
  SELECT v.*,
    CONCAT('Status: ', v.StatusText, '. Utfylt: ', CONVERT(VARCHAR, LastSignedStratify.EventTime, 104), '. Stratify-skår ', 
      StratifyScore.EnumVal, ', ', LOWER(StratifyScore.OptionText), '.')
    AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastEnumValuesTable(9257, NULL) StratifyScore ON v.PersonId = StratifyScore.PersonId
  JOIN dbo.GetLastSignedFormList(@StudyId, 'STRATIFY') LastSignedStratify ON LastSignedStratify.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListStratify] TO [FastTrak]
GO