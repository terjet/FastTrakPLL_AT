SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[ReportContactToDoList]( @ContextId INT, @IncludeInactiveStates INT ) AS
BEGIN
  SELECT DATEPART(YYYY, ip.DOB ) AS YOB, ip.Initials, 
    c.* 
  FROM Pandemic.AllContacts c
  JOIN dbo.ViewCenterCaseListStub v ON v.PersonId = c.IndexPersonId
  JOIN dbo.Study s ON s.StudyId = v.StudyId AND s.StudyName = 'COVID-19'
  JOIN dbo.Person ip ON  ip.PersonId = c.IndexPersonId
  WHERE ( c.ContextId = @ContextId ) AND ( c.StateId IN (1,2) OR @IncludeInactiveStates = 1 );
END
GO

GRANT EXECUTE ON [Pandemic].[ReportContactToDoList] TO [Gruppeleder]
GO

GRANT EXECUTE ON [Pandemic].[ReportContactToDoList] TO [Lege]
GO

GRANT EXECUTE ON [Pandemic].[ReportContactToDoList] TO [Pandemic]
GO

GRANT EXECUTE ON [Pandemic].[ReportContactToDoList] TO [Sykepleier]
GO