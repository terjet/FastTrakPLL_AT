SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListMyManualReminders]( @StudyId INT ) AS
BEGIN 
  SELECT v.* , 
    CONCAT( l.LevelDesc, ': ', a.AlertHeader, ' (fra ', dbo.ShortTime( a.HideUntil ), ')' ) AS InfoText
  FROM dbo.ViewActiveCaseListStub v 
  JOIN dbo.Alert a ON a.PersonId = v.PersonId AND a.StudyId = v.StudyId
  JOIN dbo.MetaAlertLevel l ON (l.AlertLevel = a.AlertLevel)
  WHERE v.StudyId = @StudyId AND CreatedBy = USER_ID() 
    AND a.AlertClass LIKE 'MAN#%' AND a.AlertLevel > 0 AND GETDATE() >= a.HideUntil
  ORDER BY a.AlertLevel DESC, a.HideUntil, v.FullName;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListMyManualReminders] TO [FastTrak]
GO