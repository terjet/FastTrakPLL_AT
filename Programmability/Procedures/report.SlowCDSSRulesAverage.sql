SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[SlowCDSSRulesAverage]( @StartAt DateTime = NULL, @StopAt DateTime = NULL ) AS
BEGIN
  IF dbo.DbIndexExists( 'dbo.DSSRuleExecute', 'I_RuleExecute_CreatedAt' ) = 0
  BEGIN 
    RAISERROR( 'Rapporten kan ikke kjøres fordi tabellen [DSSRuleExecute] mangler indeks på feltet [CreatedAt].', 16, 1 );
    RETURN -1;
  END;
  SET @StartAt = ISNULL( @StartAt, GETDATE() - 7 );
  SET @StopAt = ISNULL( @StopAt, GETDATE() );
  SELECT r.RuleId,r.RuleProc, MIN(re.MsElapsed) AS MinMs, AVG(re.MsElapsed) AS AvgMs, MAX(re.MsElapsed) AS MaxMs, COUNT(re.RunId) AS n
  FROM dbo.DSSRuleExecute re 
  JOIN dbo.DSSStudyRule sr ON sr.StudyRuleId=re.StudyRuleId
  JOIN dbo.DSSRule r on r.RuleId=sr.RuleId AND re.CreatedAt BETWEEN @StartAt AND @StopAt
  GROUP BY r.RuleId,r.RuleProc
  ORDER BY AvgMs DESC;
END
GO

GRANT EXECUTE ON [report].[SlowCDSSRulesAverage] TO [Administrator]
GO

GRANT EXECUTE ON [report].[SlowCDSSRulesAverage] TO [Leder]
GO

GRANT EXECUTE ON [report].[SlowCDSSRulesAverage] TO [Support]
GO