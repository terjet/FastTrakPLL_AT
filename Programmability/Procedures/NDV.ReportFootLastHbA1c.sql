SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportFootLastHbA1c]
AS
BEGIN
  SELECT DISTINCT ce.PersonId,DATEPART(yy,ce.EventTime) AS ReportYear
  INTO #tempPop
  FROM dbo.ClinEvent ce 
  JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId
  JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId
  WHERE mf.FormName='DIAPOL_FOOT';
  ALTER TABLE #tempPop ADD HbA1c DECIMAL(12,1);
  UPDATE #tempPop SET HbA1c = ( 
    SELECT TOP 1 NumResult 
	FROM dbo.LabData ld 
    JOIN dbo.LabCode lc ON lc.LabCodeId=ld.LabCodeId
    WHERE ld.PersonId=#tempPop.PersonId AND lc.LabClassId = 1058
    AND DATEPART(yy,ld.LabDate) = #tempPop.ReportYear
    AND NOT (NULLIF(NumResult,-1) IS NULL )
    ORDER BY ld.LabDate  )
  SELECT ReportYear,COUNT(PersonId) AS CountPerson,COUNT(HbA1c) AS CountHbA1c,AVG(HbA1c) AS AvgHbA1c FROM 
  #tempPop
  GROUP BY ReportYear
  ORDER BY ReportYear;
END
GO

GRANT EXECUTE ON [NDV].[ReportFootLastHbA1c] TO [FastTrak]
GO