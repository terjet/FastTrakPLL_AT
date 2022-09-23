SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListType1ByDiagnosisYear]( @StudyId INT, @Type INT ) AS 
BEGIN
  SELECT v.*, 
    CONCAT( 'Diagnoseår: ', COALESCE( CONVERT(VARCHAR, NULLIF(FLOOR(diagnosisYear.Quantity), -1)), 'Ukjent' ),
      ', HbA1c: ' + ISNULL( CONVERT(VARCHAR(7), HbA1c.NumResult ), 'mangler')) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN NDV.Type1 type1 ON type1.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastQuantityTable( 3486, NULL ) diagnosisYear ON diagnosisYear.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastLabDataTable( 1058, GETDATE() ) HbA1c ON HbA1c.PersonId = type1.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY ISNULL(NULLIF(diagnosisYear.Quantity, -1), 9999) DESC, v.FullName;
END
GO

GRANT EXECUTE ON [NDV].[GetCaseListType1ByDiagnosisYear] TO [FastTrak]
GO