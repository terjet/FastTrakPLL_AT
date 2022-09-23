SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListFormAvvikLastTertile] (@StudyId INT) AS
BEGIN
    DECLARE @KeyDate DATETIME = DATEADD(MONTH, -4, GETDATE());
    DECLARE @StartsAt DATETIME;
    DECLARE @EndsAt DATETIME;
    EXEC dbo.CalculateTertial @KeyDate, @StartsAt OUTPUT, @EndsAt OUTPUT;

    SELECT ce.PersonId, p.FullName, p.DOB, sg.GroupName,
        'Opprettet: ' + CONVERT( VARCHAR, ce.EventTime, 104 ) + ', Status: ' + mia.OptionText AS InfoText
    FROM dbo.ClinForm cf 
    JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = 'GbdAvvik'
    JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
    JOIN dbo.Person p ON p.PersonId = ce.PersonId
    JOIN dbo.UserList ul ON ul.UserId = USER_ID()
    JOIN dbo.StudyGroup sg ON ( sg.StudyId = ce.StudyId ) AND ( sg.GroupId = ce.GroupId ) AND ( sg.GroupActive = 1 ) AND ( sg.CenterId=ul.CenterId )
    LEFT JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId AND cdp.ItemId = 8512
    LEFT JOIN dbo.MetaItemAnswer mia ON mia.OrderNumber = cdp.EnumVal AND mia.ItemId = cdp.ItemId
    LEFT OUTER JOIN dbo.StudyUser su ON su.UserId = USER_ID() AND su.StudyId=ce.StudyId
    WHERE (ce.EventTime BETWEEN @StartsAt AND @EndsAt)
    AND ( ce.StudyId = @StudyId ) AND (( su.GroupId = ce.GroupId ) OR (su.UserId IS NULL) OR (su.GroupId IS NULL) OR (su.ShowMyGroup = 0));
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListFormAvvikLastTertile] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFormAvvikLastTertile] TO [Lege]
GO