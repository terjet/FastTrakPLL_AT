SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListBiobankConsentedSampleNeeded]( @StudyId INT ) AS
BEGIN
  SELECT v.*, 'Diabetes biobank prøve ikke tatt' AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastEnumValuesTable( 1502, NULL ) ev ON ev.PersonId = v.PersonId AND v.StudyId = @StudyId
  LEFT JOIN
    ( SELECT ld.PersonId, COUNT(*) AS LabCount
      FROM dbo.LabData ld
      JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
      WHERE lc.LabClassId = 1084
      GROUP BY ld.PersonId
    ) agg ON agg.PersonId = v.PersonId
  WHERE ( ev.EnumVal = 1 ) AND ( agg.LabCount IS NULL );
END;
GO

GRANT EXECUTE ON [NDV].[GetCaseListBiobankConsentedSampleNeeded] TO [FastTrak]
GO