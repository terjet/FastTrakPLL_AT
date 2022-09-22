SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddClinRelationToGroup]( @StudyId INT, @GroupId INT, @RelId INT, @UserId INT = NULL )
AS BEGIN
  DECLARE @ExpiresAt DateTime;
  IF @UserId IS NULL SET @UserId=user_id();
  SELECT @ExpiresAt = getdate() + mr.RelDuration 
  FROM MetaRelation mr 
    JOIN MetaProfession mp ON mp.ProfType=mr.ProfType
    JOIN UserList ul ON ul.UserId=@UserId AND ul.ProfId=mp.ProfId
  WHERE mr.RelId=@RelId
  IF @ExpiresAt IS NULL 
    RAISERROR('The Relation with RelId=%d not available for StudyId=%d, GroupId=%d and UserId=%d.',16,1,@RelId,@StudyId,@GroupId,@UserId)
  ELSE BEGIN
    INSERT INTO ClinRelation (PersonId,UserId,RelId,ExpiresAt)
    SELECT p.PersonId,@UserId,@RelId,@ExpiresAt FROM Person p 
      JOIN StudCase sc ON sc.PersonId=p.PersonId AND sc.StudyId=@StudyId AND sc.GroupId=@GroupId
    WHERE NOT EXISTS( SELECT ClinRelId FROM ClinRelation WHERE PersonId=p.PersonId AND UserId=@UserId );
    UPDATE ClinRelation SET ExpiresAt=@ExpiresAt, RelId=@RelId WHERE UserId=@UserId AND PersonId
      IN ( SELECT p.PersonId FROM Person p JOIN StudCase sc ON sc.PersonId=p.PersonId AND StudyId=@StudyId AND GroupId=@GroupId);
  END;
END
GO