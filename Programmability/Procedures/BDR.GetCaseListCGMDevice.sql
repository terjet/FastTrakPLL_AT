SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetCaseListCGMDevice] ( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GenderId, v.GroupName,
    ISNULL ( measure.OptionText, '(egenmåling mangler)' ) + ISNULL( ', ' + cgm.OptionText, '' ) AS InfoText,
    ISNULL( measure.EnumVal, 7 ) AS OrderBy
  FROM dbo.ViewActiveCaseListStub v
  LEFT JOIN dbo.GetLastEnumValuesTable( 1310, NULL ) measure ON measure.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable( 5166, NULL ) cgm ON cgm.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId
  ORDER BY OrderBy, cgm.OptionText, v.FullName;
END
GO

GRANT EXECUTE ON [BDR].[GetCaseListCGMDevice] TO [FastTrak]
GO