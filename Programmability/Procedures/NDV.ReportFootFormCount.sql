SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportFootFormCount]
AS
BEGIN
  SELECT DATEPART(yy,ce.EventTime) AS FormYear,COUNT(*) AS FormCount
  FROM dbo.ClinEvent ce 
  JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId
  JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId
  WHERE mf.FormName='DIAPOL_FOOT'
  GROUP BY DATEPART(yy,ce.EventTime)
  ORDER BY DATEPART(yy,ce.EventTime)
END
GO

GRANT EXECUTE ON [NDV].[ReportFootFormCount] TO [FastTrak]
GO