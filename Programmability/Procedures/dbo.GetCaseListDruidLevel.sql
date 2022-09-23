SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDruidLevel]( @StudyId INT, @AlertLevel INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, l.LevelDesc + ': ' + a.AlertHeader AS InfoText
  FROM dbo.Alert a
    JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = a.PersonId AND v.StudyId = a.StudyId
    JOIN dbo.MetaAlertLevel l ON (l.AlertLevel = a.AlertLevel )
  WHERE ( v.StudyId = @StudyId) AND ( a.AlertLevel >= @AlertLevel ) AND ( a.AlertClass LIKE 'DRUID#%' )
  ORDER BY a.AlertLevel DESC, v.PersonId;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListDruidLevel] TO [FastTrak]
GO