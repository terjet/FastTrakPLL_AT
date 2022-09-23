SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetRoasNumbersMissing] ( @StudyId INT ) AS
BEGIN
  SELECT v.*, ISNULL(CONVERT(VARCHAR, CONVERT(INT, a.Quantity)), 'Mangler') AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  LEFT JOIN dbo.GetLastQuantityTable( 6082, NULL) a ON a.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND a.Quantity IS NULL
  ORDER BY v.PersonId
END
GO

GRANT EXECUTE ON [ROAS].[GetRoasNumbersMissing] TO [FastTrak]
GO