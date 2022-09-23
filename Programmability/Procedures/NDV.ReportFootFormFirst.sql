SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportFootFormFirst]
AS
BEGIN
  SELECT ce.PersonId,DATEPART(yy,min(ce.EventTime)) as StartYear 
  INTO #temp
  FROM dbo.ClinEvent ce 
  JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId
  JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId
  WHERE mf.FormName='DIAPOL_FOOT'
  GROUP BY ce.PersonId;
  SELECT StartYear,count(*) as FormCount FROM #temp
  GROUP BY StartYear
  ORDER BY StartYear
END
GO

GRANT EXECUTE ON [NDV].[ReportFootFormFirst] TO [FastTrak]
GO