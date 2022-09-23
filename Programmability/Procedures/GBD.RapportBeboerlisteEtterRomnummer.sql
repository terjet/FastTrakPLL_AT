SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RapportBeboerlisteEtterRomnummer] ( @StudyId INT ) AS
BEGIN
    SELECT
        p.PersonId,
        p.CAVE,
        p.NB,
        p.DOB,
        p.ReverseName,
        val3.DTVal AS Arrival,
        val1.TextVal AS RoomNumber,
        mia.VerboseText AS HLR
    FROM dbo.Person p
    JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId
    JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = sc.FinState AND ss.StatusActive = 1 AND ss.StudyId = @StudyId
    JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = sc.GroupId AND sg.GroupActive = 1
    JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId = USER_ID()
    LEFT JOIN dbo.StudyUser su ON su.UserId = USER_ID() AND su.StudyId = sc.StudyId
    LEFT JOIN dbo.GetLastTextValuesTable( 3673, NULL ) val1 ON val1.PersonId = p.PersonId
    LEFT JOIN dbo.GetLastEnumValuesTable( 3437, NULL ) val2 ON val2.PersonId = p.PersonId
    LEFT JOIN dbo.GetLastDateTable( 4085, NULL ) val3 ON val3.PersonId = p.PersonId
    LEFT JOIN dbo.MetaItemAnswer mia ON mia.OrderNumber = val2.EnumVal AND mia.ItemId = 3437
    WHERE ( su.GroupId = sc.GroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 )
    ORDER BY CASE
            WHEN val1.TextVal IS NOT NULL THEN 0
            ELSE 1
    END, val1.TextVal
END;
GO

GRANT EXECUTE ON [GBD].[RapportBeboerlisteEtterRomnummer] TO [FastTrak]
GO