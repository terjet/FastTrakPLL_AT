SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListAlert]( @StudyId INT ) AS
BEGIN
  SELECT vcl.PersonId,vcl.DOB,vcl.FullName,vcl.GroupName, l.LevelDesc + ': ' + a.AlertHeader AS InfoText
  FROM ViewActiveCaseListStub vcl 
    JOIN dbo.Alert a ON a.PersonId=vcl.PersonId AND ( a.StudyId=vcl.StudyId or a.StudyId IS NULL ) 
    JOIN MetaAlertLevel l ON (l.AlertLevel=a.AlertLevel)
  WHERE ( vcl.StudyId=@StudyId) AND ( a.AlertLevel > 1 ) AND ( a.HideUntil IS NULL or a.HideUntil<=GetDate())
  ORDER BY a.AlertLevel DESC,vcl.PersonId
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListAlert] TO [Avdelingsleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAlert] TO [Leder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAlert] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAlert] TO [superuser]
GO