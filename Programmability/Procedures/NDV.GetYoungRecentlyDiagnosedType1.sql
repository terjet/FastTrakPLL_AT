SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetYoungRecentlyDiagnosedType1]( @StudyId INT ) AS
BEGIN
  select sc.PersonId,
  dbo.GetLastQuantity( sc.PersonId,'NDV_DIAGNOSE_YYYY') AS NDV_DIAGNOSE_YYYY,
  dbo.GetLastEnumVal( sc.PersonId,'NDV_TYPE') AS NDV_TYPE
  INTO #temp
  FROM dbo.StudCase sc
  JOIN dbo.Person p ON p.PersonId=sc.PersonId 
  WHERE ( p.DOB >= '1988-01-01' ) AND ( p.DOB < DATEADD(yy,-18,getdate() ) )
  AND sc.StudyId=@StudyId;
  DELETE FROM #temp 
  WHERE PersonId IN ( SELECT DISTINCT PersonId FROM dbo.ClinEvent WHERE EventTime < '2012-01-01' )
  OR ( NDV_DIAGNOSE_YYYY < 2012 ) OR ( NDV_TYPE <> 1 )
  SELECT p.PersonId,p.DOB,p.ReverseName as FullName,'Alle grupper' as GroupName,
  'Diagnoseår: ' + ISNULL(CONVERT(VARCHAR,CONVERT(INT,NDV_DIAGNOSE_YYYY)),'Uoppgitt') AS InfoText FROM #temp t
  JOIN dbo.Person p ON p.PersonId=t.PersonId
  ORDER BY DOB
END
GO

GRANT EXECUTE ON [NDV].[GetYoungRecentlyDiagnosedType1] TO [FastTrak]
GO