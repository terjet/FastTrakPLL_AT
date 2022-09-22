SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListAF]( @StudyId INT ) AS
BEGIN
  SELECT DISTINCT v.PersonId,v.DOB,v.FullName,v.GroupName,ISNULL(ISNULL(dt1.DrugName,dt2.DrugName),'Ubehandlet') as InfoText
  FROM ViewActiveCaseListStub v
  LEFT OUTER JOIN DrugTreatment dt1 ON dt1.PersonId=v.PersonId AND dt1.ATC = 'B01AA03' AND dt1.StopAt IS NULL
  LEFT OUTER JOIN DrugTreatment dt2 ON dt2.PersonId=v.PersonId AND dt2.ATC = 'B01AC06' AND dt2.StopAt IS NULL
  LEFT OUTER JOIN dbo.ClinProblem cp ON cp.PersonId=v.PersonId
  LEFT OUTER JOIN dbo.ClinEvent ce ON ce.StudyId=v.StudyId AND ce.PersonId=v.PersonId
  LEFT OUTER JOIN dbo.ClinObservation co ON co.EventId=ce.EventId and co.VarName='EKG_AF' AND co.Quantity=1
  JOIN MetaNomListItem li ON li.ListItem=cp.ListItem
  JOIN MetaNomItem i on i.ItemId=li.ItemId AND i.ItemCode like 'I48%'
  WHERE v.StudyId = @StudyId
  ORDER BY GroupName
END
GO