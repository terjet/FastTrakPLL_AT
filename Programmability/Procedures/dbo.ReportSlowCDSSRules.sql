SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportSlowCDSSRules]
AS
BEGIN
  select top 100 re.PersonId,r.RuleProc,re.CreatedAt,re.MsElapsed from DSSRuleExecute re 
  JOIN DSSStudyRule sr on sr.StudyRuleId=re.StudyRuleId
  JOIN DSSRule r on r.RuleId=sr.RuleId
  AND re.CreatedAt> getdate()-7
  order by MsElapsed desc
END
GO