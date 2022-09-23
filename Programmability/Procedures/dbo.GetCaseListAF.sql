SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListAF]( @StudyId INT ) AS
BEGIN
  -- TODO: Make more effective by using GetLastEnumValTable( 4227 )
  SELECT DISTINCT v.PersonId, v.DOB, v.FullName, v.GroupName,
    ISNULL(ISNULL(dt1.DrugName,ISNULL(dt2.DrugName,ISNULL(dt3.DrugName,dt4.DrugName))),'Ubehandlet') AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  LEFT OUTER JOIN dbo.DrugTreatment dt1 ON dt1.PersonId=v.PersonId AND dt1.ATC = 'B01AA03' AND dt1.StopAt IS NULL
  LEFT OUTER JOIN dbo.DrugTreatment dt2 ON dt2.PersonId=v.PersonId AND dt2.ATC LIKE 'B01AE%' AND dt2.StopAt IS NULL
  LEFT OUTER JOIN dbo.DrugTreatment dt3 ON dt3.PersonId=v.PersonId AND dt3.ATC LIKE 'B01AF%' AND dt3.StopAt IS NULL
  LEFT OUTER JOIN dbo.DrugTreatment dt4 ON dt4.PersonId=v.PersonId AND dt4.ATC LIKE 'B01AC%' AND dt4.StopAt IS NULL
  LEFT OUTER JOIN dbo.ClinProblem cp ON cp.PersonId = v.PersonId
  LEFT OUTER JOIN dbo.ClinEvent ce ON ce.StudyId = v.StudyId AND ce.PersonId = v.PersonId
  LEFT OUTER JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId AND cdp.ItemId = 4227 AND cdp.Quantity = 1
  JOIN dbo.MetaNomListItem li ON li.ListItem = cp.ListItem
  JOIN dbo.MetaNomItem i ON i.ItemId=li.ItemId AND i.ItemCode like 'I48%'
  WHERE v.StudyId = @StudyId
  ORDER BY v.GroupName, v.FullName; 
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListAF] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAF] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAF] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAF] TO [Vernepleier]
GO