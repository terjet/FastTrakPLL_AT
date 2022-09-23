SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetGravide]( @StudyId INT ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT ce.PersonId,COUNT(*) AS Antall,CONVERT(DATE,MAX(ce.EventTime)) AS SisteDato
  INTO #temp1 FROM dbo.ClinEvent ce
  JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId AND DeletedAt IS NULL
  JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId 
  WHERE mf.FormName = 'DIAPOL_GRAVIDE'
  GROUP BY ce.PersonId;
  -- Get type
  SELECT t1.PersonId,DiaType = 
    CASE dbo.GetLastEnumVal(t1.PersonId,'NDV_TYPE') 
      WHEN 1 THEN 'Type 1'
      WHEN 2 THEN 'Type 2'
      WHEN 5 THEN 'Svskap'
      ELSE 'Andre' 
     END
  INTO #temp2 FROM #temp1 t1;
  -- Get result set  
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,
    DiaType + '. Ktr=' + CONVERT(VARCHAR,t1.Antall) + ', sist ' + CONVERT(VARCHAR,t1.SisteDato,104) + '.' AS InfoText
  FROM dbo.ViewFullCaseListStub v 
  JOIN #temp1 t1 ON t1.PersonId=v.PersonId
  JOIN #temp2 t2 ON t2.PersonId=v.PersonId
  WHERE v.StudyId=@StudyId;
END
GO

GRANT EXECUTE ON [NDV].[GetGravide] TO [FastTrak]
GO