SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListBiobankUnanswered]( @StudyId INT ) AS
BEGIN
  SELECT v.*, 'Ubesvart samtykke til diabetes biobank' AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  LEFT OUTER JOIN dbo.GetLastEnumValuesTable( 1502, NULL ) c ON c.PersonId = v.PersonId 
  WHERE ( v.StudyId = @StudyId ) AND ( ISNULL( c.EnumVal, -1 ) IN ( -1, 4 ) )
  ORDER BY FullName;
END;
GO

GRANT EXECUTE ON [NDV].[GetCaseListBiobankUnanswered] TO [FastTrak]
GO