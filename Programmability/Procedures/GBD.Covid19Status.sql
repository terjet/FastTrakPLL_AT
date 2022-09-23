SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[Covid19Status]( @StudyId INT, @IncludeInactiveStates INT ) AS
BEGIN

  SET NOCOUNT ON;

  -- Not interested in NEWS2 data older than six months
  DECLARE @NEWS2CutOffDate DATETIME = DATEADD( dd, -180, GETDATE() );
  
  -- Select all variables from the most recent NEWS2 form that fill the above criterion
  SELECT lastNEWS2.PersonId, cf.ClinFormId, lastNEWS2.EventTime AS FormDate, cf.FormComplete,
    cdp.ItemId, cdp.EnumVal, cdp.Quantity 
  INTO #NEWS2Data
    FROM dbo.GetLastFormTableByName( 'NEWS2', NULL ) lastNEWS2
  JOIN dbo.ClinForm cf ON cf.ClinFormId = lastNEWS2.ClinFormId
  JOIN dbo.ClinDataPoint cdp ON cdp.EventId = lastNEWS2.EventId
  WHERE cdp.ItemId IN (2845, 1530, 1621, 2842, 1405, 1622, 1623, 1624, 2840) AND lastNEWS2.EventTime >= @NEWS2CutOffDate;

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
      news.FormDate AS NEWS2Date,
      CASE WHEN news.FormComplete > 90 THEN 1 ELSE 0 END AS NEWS2Complete,
      ISNULL(news.Quantity, -1) AS NEWS2Score,
      news2Param.HasParameterWithScoreThree AS NEWS2ParameterScoreThree,
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
    LEFT JOIN dbo.GetLastEnumValuesTable( 6916, NULL ) risiko_faktorer
        ON risiko_faktorer.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastDateTable( 6942, NULL ) smittesporing_startet
        ON smittesporing_startet.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable( 5329, NULL ) smittesporing_status
        ON smittesporing_status.PersonId = v.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable( 5350, NULL ) smitte_status
        ON smitte_status.PersonId = v.PersonId
    -- NEWS2
    LEFT JOIN #NEWS2Data news
        ON news.PersonId = v.PersonId AND news.ItemId = 2845
    LEFT JOIN 
      ( SELECT news.PersonId, MAX( CASE WHEN mia.Score = 3 THEN 1 ELSE 0 END ) AS HasParameterWithScoreThree
        FROM #NEWS2Data news
        JOIN dbo.MetaItemAnswer mia ON mia.ItemId = news.ItemId AND mia.OrderNumber = news.EnumVal
        WHERE mia.ItemId IN (1530, 1621, 2842, 1405, 1622, 1623, 1624, 2840)
        GROUP BY news.PersonId ) news2Param
        ON news2Param.PersonId = v.PersonId
    WHERE ( v.StudyId = @StudyId ) 
      AND ( ( @IncludeInactiveStates = 1 AND sc.LastWrite > '2020-03-01' ) OR ( ss.StatusActive = 1 ) )
      AND ( ( su.GroupId = v.GroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 ) )
    ORDER BY ss.StatusText, v.GroupName, v.FullName; 
END
GO

GRANT EXECUTE ON [GBD].[Covid19Status] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[Covid19Status] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[Covid19Status] TO [Pandemic]
GO

GRANT EXECUTE ON [GBD].[Covid19Status] TO [Sykepleier]
GO