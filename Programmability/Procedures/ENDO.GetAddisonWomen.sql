SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetAddisonWomen]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, v.GenderId,
    'Diagnoseår ' + ISNULL(CONVERT(VARCHAR, CONVERT(INT, T6089.Quantity)), 'mangler') + ', ' +
    ISNULL(T6090.OptionText, '(subtype mangler)') + '.' AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  LEFT JOIN dbo.GetLastEnumValuesTable( 6090, NULL ) AS T6090 ON T6090.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable( 6299, NULL ) AS T6299 ON T6299.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastQuantities( 6089 ) AS T6089 ON T6089.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND (T6090.EnumVal = 1 OR T6299.EnumVal = 1 OR T6089.Quantity > 1900)
    AND v.GenderId = 2;
END
GO

GRANT EXECUTE ON [ENDO].[GetAddisonWomen] TO [FastTrak]
GO