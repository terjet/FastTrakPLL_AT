SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDruidLevel]( @StudyId INT, @AlertLevel INT ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT vcl.PersonId,vcl.DOB,vcl.FullName,sg.GroupName, l.LevelDesc + ': ' + a.AlertHeader AS InfoText
  FROM dbo.Alert a
    JOIN ViewActiveCaseListStub vcl ON vcl.PersonId=a.PersonId
    JOIN StudCase sc ON (sc.PersonId=vcl.PersonId) AND (sc.StudyId=a.StudyId)
    JOIN MetaAlertLevel l ON (l.AlertLevel=a.AlertLevel)
    LEFT OUTER JOIN dbo.StudyGroup sg ON sg.GroupId=sc.GroupId and sg.StudyId=sc.StudyId
  WHERE ( a.StudyId=@StudyId) AND ( a.AlertLevel = @AlertLevel ) AND (AlertClass LIKE 'DRUID#%')
  ORDER BY a.AlertLevel DESC,vcl.PersonId
END;
GO