SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetRoasNumbersMissingAddison] ( @StudyId INT ) AS
BEGIN
  SELECT v.*, ISNULL(CONVERT(VARCHAR, CONVERT(INT, a.Quantity)), 'Mangler') AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastEnumValuesTable( 6090, NULL ) b ON b.PersonId = v.PersonId AND ( b.EnumVal IN (1,2,3,4,5) )
  LEFT JOIN dbo.GetLastQuantityTable( 6082, NULL) a ON a.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND a.Quantity IS NULL
  ORDER BY v.PersonId
END
GO

GRANT EXECUTE ON [ROAS].[GetRoasNumbersMissingAddison] TO [FastTrak]
GO