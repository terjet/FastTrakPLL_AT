SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListAnticholinergic]( @StudyId INT ) AS 
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, ot.DrugName, ac.AlertLevel,
   'Nivå ' + CONVERT(VARCHAR,AlertLevel) + ': (' + 
    ot.DrugName + COALESCE( ') ' + dd.ItemCode + ' ' + dd.ItemName, ') ikke demens.' ) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.OngoingTreatment ot ON ot.PersonId=v.PersonId
  JOIN dbo.KBAnticholinDrug ac ON ac.ATC=ot.ATC
  LEFT JOIN Diagnose.Dementia dd ON dd.PersonId=v.PersonId
  WHERE ac.AlertLevel IN ('A','B')
  ORDER BY ac.AlertLevel, FullName;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListAnticholinergic] TO [Farmasøyt]
GO

GRANT EXECUTE ON [GBD].[GetCaseListAnticholinergic] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListAnticholinergic] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListAnticholinergic] TO [Vernepleier]
GO