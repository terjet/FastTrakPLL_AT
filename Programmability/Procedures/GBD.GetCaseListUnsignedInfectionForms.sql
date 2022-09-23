SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListUnsignedInfectionForms]( @StudyId INT ) AS
BEGIN
  SELECT 
    p.PersonId, p.DOB, p.FullName, sg.GroupName, mf.FormTitle + ', ' + dbo.LongTime(ce.EventTime) AS InfoText,
    p.GenderId, p.NationalId
  FROM dbo.ClinForm cf
    JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
    JOIN dbo.StudyGroup sg ON sg.GroupId = ce.GroupId AND sg.StudyId = @StudyId
    JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId = USER_ID()
    JOIN dbo.Person p ON p.PersonId = ce.PersonId
    JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = 'GBD_INFECTION'
    LEFT OUTER JOIN dbo.StudyUser su ON su.UserId = USER_ID() AND su.StudyId = sg.StudyId
  WHERE ( cf.SignedAt IS NULL ) AND ( cf.DeletedAt IS NULL ) AND ( DATEDIFF(d, ce.EventTime, GETDATE()) <= 180 )
    AND ( ( su.GroupId=sg.GroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 ) )
  ORDER BY ce.EventTime;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListUnsignedInfectionForms] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListUnsignedInfectionForms] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListUnsignedInfectionForms] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListUnsignedInfectionForms] TO [Vernepleier]
GO