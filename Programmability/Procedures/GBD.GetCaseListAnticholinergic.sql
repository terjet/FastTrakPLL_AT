SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListAnticholinergic]( @StudyId INT ) AS 
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,ot.DrugName,ac.AlertLevel,CONVERT(INT,dbo.GetLastQuantity(v.PersonId,'BERGER_SKALA')) as Berger
  INTO #temp 
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.OngoingTreatment ot ON ot.PersonId=v.PersonId
  JOIN dbo.KBAnticholinDrug ac ON ac.ATC=ot.ATC;
  SELECT PersonId,DOB,FullName,GroupName,'Nivå ' + CONVERT(VARCHAR,AlertLevel) + ' (' + DrugName + ') Berger: ' + ISNULL(CONVERT(VARCHAR,Berger),'Ukjent') AS InfoText
  FROM #temp
  WHERE AlertLevel IN ('A','B')
  ORDER BY AlertLevel,Berger DESC,FullName
END
GO