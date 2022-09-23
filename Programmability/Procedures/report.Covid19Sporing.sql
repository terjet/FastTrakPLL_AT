SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[Covid19Sporing]( @StudyId INT, @ExcludeCompleted INT ) AS
BEGIN
  /* Shared between GBD and COVID-19 */
  SELECT v.*, 
    IIF( D7732.DTVal < '2020-03-01', NULL, D7732.DTVal ) AS smitte_paavist,
    IIF( D6942.DTVal < '2020-03-01', NULL, D6942.DTVal ) AS sporing_startet,
    E5329.OptionText                                     AS intern_smittesporing,
    T7734.TextVal                                        AS intern_smittesporing_ansvar,
    IIF(D9265.DTVal<'2020-03-01', NULL,D9265.DTVal)      AS fullfoert_sporing,
    -- Version 1 report (GBD and old COVID-19)
    E7727.OptionText                                     AS smitte_meldt,       -- Yes/No
    T9262.TextVal                                        AS smitte_meldt_til,   -- Reported to whom
    -- Version 2 report (new COVID-19)
    E9749.OptionText                                     AS E9749,              -- Kommunelege
    E9750.OptionText                                     AS E9750               -- FHI
  FROM dbo.ViewCenterCaseListStub v                                                                                                                
    JOIN      dbo.GetLastEnumValuesTable( 5350, NULL ) E5350 ON E5350.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastDateTable( 6942, NULL ) D6942       ON D6942.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastDateTable( 7732, NULL ) D7732       ON D7732.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable( 5329, NULL ) E5329 ON E5329.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastTextValuesTable( 7734, NULL) T7734  ON T7734.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastDateTable( 9265, NULL ) D9265       ON D9265.PersonId = v.PersonId 
    -- Version 1 report (GBD and old COVID-19)
    LEFT JOIN dbo.GetLastEnumValuesTable( 7727, NULL ) E7727 ON E7727.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastTextValuesTable( 9262, NULL) T9262  ON T9262.PersonId = v.PersonId
    -- Version 2 report (new COVID-19)
    LEFT JOIN dbo.GetLastEnumValuesTable( 9749, NULL) E9749  ON E9749.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable( 9750, NULL) E9750  ON E9750.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId 
    AND ((ISNULL(E5329.EnumVal,-1) <> 3 AND @ExcludeCompleted = 1) OR  @ExcludeCompleted = 0)
    AND E5350.EnumVal = 1
  ORDER BY v.FullName;
END;
GO

GRANT EXECUTE ON [report].[Covid19Sporing] TO [Gruppeleder]
GO

GRANT EXECUTE ON [report].[Covid19Sporing] TO [Lege]
GO

GRANT EXECUTE ON [report].[Covid19Sporing] TO [Pandemic]
GO

GRANT EXECUTE ON [report].[Covid19Sporing] TO [Sykepleier]
GO