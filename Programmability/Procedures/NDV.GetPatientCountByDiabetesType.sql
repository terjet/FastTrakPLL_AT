SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetPatientCountByDiabetesType] AS
BEGIN
  SELECT 
	DiaOrderNumber,REPLACE( DiaOptionText,'*', '') AS DiaOptionText, 
	SamtOrderNumber,REPLACE( SamtOptionText,'*', '') AS SamtOptionText, 
	COUNT(a.PersonId) AS PatientCount
  FROM
  (
    SELECT DISTINCT 
	  vac.PersonId, 
		ISNULL(est.EnumVal,0) AS SamtOrderNumber, ISNULL(est.OptionText, 'Samtykke er ubesvart!') AS SamtOptionText,
		ISNULL(edt.EnumVal,0) AS DiaOrderNumber, ISNULL(edt.OptionText, 'Diabetes type er ubesvart.') AS DiaOptionText
    FROM dbo.ViewActiveCaseListStub vac
	JOIN dbo.Study s ON ( s.StudyId = vac.StudyId ) AND ( s.StudyName IN ( 'NDV','ENDO' ) )
    JOIN dbo.GetLastEnumValuesTable( 3196, NULL ) edt ON edt.PersonId=vac.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable( 3389, NULL ) est ON est.PersonId=vac.PersonId
  ) a
  GROUP BY a.SamtOrderNumber, a.SamtOptionText, a.DiaOrderNumber, a.DiaOptionText 
  ORDER BY a.DiaOrderNumber,a.SamtOrderNumber
END
GO

GRANT EXECUTE ON [NDV].[GetPatientCountByDiabetesType] TO [FastTrak]
GO