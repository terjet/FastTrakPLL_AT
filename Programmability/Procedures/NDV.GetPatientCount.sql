SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetPatientCount] AS
BEGIN

    SET NOCOUNT ON;

    -- Create temp table to be able to do percentages.

    SELECT DISTINCT vac.PersonId, ISNULL(ev.EnumVal,0) AS OrderNumber, ISNULL(ev.OptionText,'Samtykke er ubesvart!') AS OptionText
    INTO #temp
    FROM dbo.ViewActiveCaseListStub vac
    JOIN dbo.Study s ON ( s.StudyId = vac.StudyId ) AND ( s.StudyName IN ( 'NDV','ENDO' ) )
    LEFT JOIN dbo.GetLastEnumValuesTable( 3389, NULL ) ev ON ev.PersonId=vac.PersonId;

    -- Count total
    DECLARE @PatientCount FLOAT;
    SELECT @PatientCount = COUNT(PersonId) FROM #temp;

  -- Get final resultset

    SELECT OrderNumber,REPLACE( OptionText,'*', '') AS OptionText,
    COUNT(PersonId) AS PatientCount, 100 * COUNT(PersonId)/@PatientCount AS PercentOfTotal
    FROM #temp
    GROUP BY OrderNumber, OptionText
    ORDER BY OrderNumber

END
GO

GRANT EXECUTE ON [NDV].[GetPatientCount] TO [FastTrak]
GO