SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetManualAlerts]( @StudyId INT ) AS
BEGIN

    SET LANGUAGE Norwegian;
    
    SELECT v.PersonId, v.DOB, v.FullName, a.AlertHeader AS T5601, 
       SUBSTRING(a.AlertMessage, 1, CHARINDEX('( <a href', a.AlertMessage) - 1) AS T5602, 
       a.AlertButtons AS T5603, a.HideUntil AS T5604, ce.EventTime, up.signature AS CreatedBySign
    FROM dbo.Alert a
    JOIN dbo.ViewActiveCaseListStub v ON v.StudyId = a.StudyId
        AND v.PersonId = a.PersonId
    JOIN dbo.ClinForm cf ON cf.ClinFormId = CONVERT(INTEGER, SUBSTRING(AlertClass, 4, 15))
    JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
    JOIN dbo.UserList ul ON ul.UserId = cf.CreatedBy
    LEFT OUTER JOIN dbo.Person up ON up.PersonId = ul.PersonId
    WHERE (AlertClass LIKE 'CF#%')
    AND (v.StudyId = @StudyId)
    AND (a.HideUntil > GETDATE() - 7)
    AND (a.HideUntil < GETDATE() + 3650)
    
    UNION
    
    SELECT v.PersonId, v.DOB, v.FullName, a.AlertHeader AS T5601, 
      a.AlertMessage AS T5602, 
      a.AlertButtons AS T5603, a.HideUntil AS T5604, 
      a.CreatedAt AS EventTime, up.signature AS CreatedBySign
    FROM dbo.Alert a
    JOIN dbo.ViewActiveCaseListStub v ON v.StudyId = a.StudyId
        AND v.PersonId = a.PersonId
	JOIN dbo.UserList ul ON ul.UserId = a.CreatedBy
    LEFT OUTER JOIN dbo.Person up ON up.PersonId = ul.PersonId
    WHERE (AlertClass LIKE 'MAN#%')
    AND (v.StudyId = @StudyId)
    AND (a.HideUntil > GETDATE() - 7)
    AND (a.HideUntil < GETDATE() + 3650)
    ORDER BY a.HideUntil DESC;         
    
END
GO

GRANT EXECUTE ON [report].[GetManualAlerts] TO [FastTrak]
GO