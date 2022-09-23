SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[TorClaudiLadaHunt]( @StudyId INT )  AS
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,'Mulig LADA?' as InfoText,
  p.GenderId,
  DateDiff(yy,v.DOB,getdate()) as AgeNow,
  CONVERT( INT, ISNULL(dbo.GetLastQuantity( v.PersonId,'NDV_DIAGNOSE_YYYY'),9999)) as NDV_DIAGNOSE_YYYY,
  ISNULL(dbo.GetLastEnumVal( v.PersonId,'NDV_ANTIBODY' ),9) as NDV_ANTIBODY 
  FROM dbo.ViewActiveCaseListStub v 
  JOIN dbo.Person p on p.PersonId =v.PersonId
  WHERE v.StudyId=@StudyId 
  AND DateDiff( yy, v.DOB, getdate()) >= 30 
  AND DateDiff( yy, v.DOB, getdate()) <= 75
  AND ISNULL(dbo.GetLastQuantity( v.PersonId,'NDV_DIAGNOSE_YYYY'),9999) >= 2009
  AND ISNULL(dbo.GetLastEnumVal( v.PersonId,'NDV_ANTIBODY' ),9) = 1
END
GO

GRANT EXECUTE ON [NDV].[TorClaudiLadaHunt] TO [FastTrak]
GO