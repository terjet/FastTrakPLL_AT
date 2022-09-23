SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListTvangsvedtak]( @StudyId INT ) AS
BEGIN
  SELECT p.PersonId,p.DOB,p.FullName,p.GroupName,
    'Vedtak ' + CONVERT(VARCHAR,tv.EventTime,4) + ' gyldig til ' + CONVERT(VARCHAR,tv.StopDate,4) AS InfoText
  FROM dbo.ViewActiveCaseListStub p
  JOIN GBD.Tvangsvedtak tv ON tv.StudyId=p.StudyId AND tv.PersonId=p.PersonId AND tv.StudyId=@StudyId
  WHERE tv.StopDate >= getdate();
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListTvangsvedtak] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListTvangsvedtak] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListTvangsvedtak] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListTvangsvedtak] TO [Vernepleier]
GO