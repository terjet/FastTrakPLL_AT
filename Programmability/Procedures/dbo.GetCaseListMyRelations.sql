SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListMyRelations]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,r.RelName as InfoText
  FROM ViewActiveCaseListStub v     
    JOIN ClinRelation cr on cr.PersonId=v.PersonId AND cr.UserId=user_id()
    JOIN UserList ul on ul.UserId=cr.UserId
    LEFT OUTER JOIN Person up on up.PersonId=ul.PersonId
    JOIN MetaRelation r on r.RelId=cr.RelId
  WHERE v.StudyId=@StudyId AND cr.ExpiresAt > getdate() 
  ORDER BY v.FullName
END
GO