SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNoForm]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,'Opprettet ' + dbo.ShortTime( sc.CreatedAt ) as InfoText
  FROM ViewActiveCaseListStub v
  JOIN StudCase sc ON sc.PersonId=v.PersonId AND sc.StudyId=v.StudyId
  WHERE v.StudyId=@StudyId 
  AND NOT EXISTS ( SELECT ce.EventId FROM ClinEvent ce WHERE ce.PersonId=v.PersonId and ce.StudyId=v.StudyId );
END
GO