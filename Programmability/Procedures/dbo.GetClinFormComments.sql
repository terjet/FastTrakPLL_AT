SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClinFormComments]( @SessId INT, @PersonId INT ) AS
BEGIN
  DECLARE @StudyId INT;
  SET @StudyId = dbo.GetStudyId( @SessId );
    SELECT cf.ClinFormId,cf.Comment,cf.CreatedAt,p1.Signature as CreatedBySign,cf.SignedAt,p2.Signature as SignedBySign
    FROM ClinForm cf
    JOIN dbo.ClinEvent ce on ce.EventId=cf.EventId AND ce.PersonId=@PersonId AND ce.StudyId=@StudyId
    LEFT OUTER JOIN dbo.UserList u1 on u1.UserId=cf.CreatedBy
    LEFT OUTER JOIN dbo.UserList u2 on u2.UserId=cf.SignedBy
    LEFT OUTER JOIN dbo.Person p1 on p1.PersonId=u1.PersonId
    LEFT OUTER JOIN dbo.Person p2 on p2.PersonId=u2.PersonId
  ORDER BY cf.ClinFormId;
END
GO

GRANT EXECUTE ON [dbo].[GetClinFormComments] TO [FastTrak]
GO