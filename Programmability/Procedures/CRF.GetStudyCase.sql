SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetStudyCase]( @StudyId INT, @PersonId INT ) AS
BEGIN
  SELECT 
    p.*, sc.StudCaseId,
    cr.ClinRelId, mr.RelId, mr.RelName,
    sg.GroupId, sg.GroupName, ss.StatusId, ss.StatusText, ss.StatusActive,
    c.CenterId, c.CenterName, 
    ppc.Signature AS PrimaryContactSign, ppc.FullName AS PrimaryContactName,
    uja.UserId AS Journalansvarlig,
    pja.FullName AS JournalansvarligNavn
  FROM dbo.Person p
    LEFT JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId AND sc.StudyId = @StudyId
    LEFT JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = sc.FinState
    LEFT JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = sc.GroupId
    LEFT JOIN dbo.StudyCenter c ON c.CenterId = sg.CenterId
    LEFT JOIN dbo.ClinRelation cr ON cr.PersonId = sc.PersonId AND cr.UserId = USER_ID() AND ExpiresAt > getdate()
    LEFT JOIN dbo.MetaRelation mr ON mr.RelId = cr.RelId
    LEFT JOIN dbo.UserList upc ON upc.UserId = sc.HandledBy
    LEFT JOIN dbo.UserList uja ON uja.UserId = sc.Journalansvarlig
    LEFT JOIN dbo.Person ppc ON ppc.PersonId = upc.PersonId
    LEFT JOIN dbo.Person pja ON pja.PersonId = uja.PersonId
  WHERE p.PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [CRF].[GetStudyCase] TO [FastTrak]
GO