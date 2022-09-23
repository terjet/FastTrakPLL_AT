SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListAllManualReminders]( @StudyId INT ) AS
BEGIN
  SELECT v.* , 
    CONCAT( l.LevelDesc, ': ', a.AlertHeader, ' (fra ', dbo.ShortTime( a.HideUntil), '; ', p.Signature, ')') AS InfoText
  FROM dbo.ViewActiveCaseListStub v 
  JOIN dbo.Alert a ON a.PersonId = v.PersonId AND a.StudyId = v.StudyId
  JOIN dbo.MetaAlertLevel l ON (l.AlertLevel = a.AlertLevel)
  JOIN dbo.UserList u ON u.UserId = a.CreatedBy
  JOIN dbo.Person p ON u.PersonId = p.PersonId
  WHERE v.StudyId = @StudyId 
    AND a.AlertClass LIKE 'MAN#%' AND a.AlertLevel > 0 AND GETDATE() >= a.HideUntil
  ORDER BY a.AlertLevel DESC, a.HideUntil, v.FullName;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListAllManualReminders] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAllManualReminders] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAllManualReminders] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAllManualReminders] TO [Vernepleier]
GO