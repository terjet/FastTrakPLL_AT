SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetActiveDeceased]( @StudyId INT ) AS
BEGIN
  select v.*,'Død ' + CONVERT(VARCHAR,p.DeceasedDate,106)+ ' ('+ss.StatusText+')' AS InfoText FROM 
  dbo.ViewActiveCaseListStub v
  JOIN dbo.StudyCase sc ON sc.StudyId=v.StudyId AND sc.PersonId=v.PersonId
  JOIN dbo.StudyStatus ss ON ss.StudyId=v.StudyId AND ss.StatusId=sc.StatusId
  JOIN dbo.Person p ON p.PersonId=v.PersonId
  WHERE (not p.DeceasedDate IS NULL) AND ( sc.StatusId<>2 ) AND ( v.StudyId=@StudyId )
  ORDER BY p.DeceasedDate DESC
END
GO

GRANT EXECUTE ON [dbo].[GetActiveDeceased] TO [FastTrak]
GO