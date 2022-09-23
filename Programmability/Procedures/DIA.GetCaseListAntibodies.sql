SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [DIA].[GetCaseListAntibodies]( @StudyId INT ) AS
BEGIN
  SELECT v.*, CONCAT( ISNULL(ant.OptionText,'Ubesvart'), ': ', ISNULL(txt.TextVal, '(ingen kommentar)') ) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  LEFT JOIN dbo.GetLastEnumValuesTable( 3981, NULL ) ant ON ant.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastTextValuesTable( 9002, NULL ) txt ON txt.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY ant.OptionText, v.DOB;
END
GO

GRANT EXECUTE ON [DIA].[GetCaseListAntibodies] TO [FastTrak]
GO