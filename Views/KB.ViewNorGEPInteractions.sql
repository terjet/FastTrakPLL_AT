SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [KB].[ViewNorGEPInteractions]
AS
  SELECT p.StudyId,p.PersonId,p.DOB,p.FullName,p.GroupName,ng.NgId,ng.IntId,a.AlertLevel,a.AlertHeader,i.InfoText,n.Warning 
  FROM dbo.Alert a 
  JOIN KB.InteractionNorGEP ng ON ng.AlertClass=a.AlertClass
  JOIN KB.NorGEP n ON n.Id=ng.NgId
  JOIN dbo.KbInteraction i ON i.IntId=ng.IntId
  JOIN dbo.ViewActiveCaseListStub p on p.PersonId=a.PersonId and p.StudyId=a.StudyId
  WHERE AlertLevel > 0
GO