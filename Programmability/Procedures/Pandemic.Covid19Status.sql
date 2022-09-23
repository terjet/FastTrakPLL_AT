SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[Covid19Status]( @StudyId INT, @IncludeInactiveStates INT ) AS
BEGIN
  SELECT v.*, ss.StatusText,
    CASE 
      WHEN 
        form_screening.ClinFormId > 0 AND cf1.FormComplete = 100 
        THEN 1
      ELSE 0
      END screenet,
      ISNULL( mistenkt.EnumVal, -1 ) AS mistenkt,
      ISNULL( symptomer.EnumVal, -1 ) AS symptomer,
      ISNULL( risiko_faktorer.EnumVal,-1) AS risiko_faktorer,
      ISNULL( smittesporing_status.EnumVal, -1 ) AS smittesporing_status,
      ISNULL( smitte_status.EnumVal, -1 ) AS smitte_status,
      smittesporing_startet.DTVal AS smittesporing_startet,
      CONVERT( DATE, form_screening.EventTime ) AS EventTime,
      CONVERT( DATE, form_testing.EventTime ) AS TestTime,
      DATEDIFF( DD, form_testing.EventTime, GETDATE() ) AS TestAge 
    FROM dbo.ViewCenterCaseListStub v
    JOIN dbo.StudCase sc 
        ON sc.StudyId = v.StudyId AND sc.PersonId = v.PersonId         
    JOIN dbo.StudyStatus ss 
        ON v.StudyId = ss.StudyId AND ss.StatusId = v.FinState
    LEFT JOIN dbo.StudyUser su 
        ON su.UserId = USER_ID() AND su.StudyId = v.StudyId
    LEFT JOIN dbo.GetLastFormTableByName( 'COVID_19_SCREENING', NULL) form_screening
        ON form_screening.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastFormTableByName( 'COVID_19_TESTING', NULL ) form_testing
        ON form_testing.PersonId = v.PersonId
    LEFT JOIN dbo.ClinForm cf1
        ON cf1.ClinFormId = form_screening.ClinFormId AND cf1.FormComplete = 100
    LEFT JOIN dbo.GetLastEnumValuesTable( 6940, NULL ) mistenkt
        ON mistenkt.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable( 5328, NULL ) symptomer
        ON symptomer.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable( 9748, NULL ) risiko_faktorer
        ON risiko_faktorer.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastDateTable( 6942, NULL ) smittesporing_startet
        ON smittesporing_startet.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable( 5329, NULL ) smittesporing_status
        ON smittesporing_status.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable( 5350, NULL ) smitte_status
        ON smitte_status.PersonId = v.PersonId
    WHERE ( v.StudyId = @StudyId ) 
      AND ( ( @IncludeInactiveStates = 1 AND sc.LastWrite > '2020-03-01' ) OR ( ss.StatusActive = 1 ) )
      AND ( ( su.GroupId = v.GroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 ) )
    ORDER BY ss.StatusText, v.GroupName, v.FullName; 
END
GO

GRANT EXECUTE ON [Pandemic].[Covid19Status] TO [Pandemic]
GO