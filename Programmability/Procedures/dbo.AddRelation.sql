SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddRelation]( @PersonId INT, @RelId INT, @UserId INT = NULL)
AS
BEGIN
  DECLARE @Duration FLOAT;   
  DECLARE @ClinRelId INT;
  IF @UserId IS NULL SET @UserId=USER_ID();           
  /* Check that this relation is available for this user */
  SELECT @Duration = RelDuration FROM MetaRelation mr
    JOIN MetaProfession mp ON mp.ProfType=mr.ProfType 
    JOIN UserList ul ON ul.ProfId=mp.ProfId
    WHERE RelId=@RelId;
  IF NOT @Duration IS NULL BEGIN
    /* Check for an existing relation */ 
    SELECT @ClinRelId = ClinRelId FROM ClinRelation WHERE UserId=@UserId AND PersonId=@PersonId;
    IF @ClinRelId IS NULL
      INSERT INTO ClinRelation (PersonId,UserId,RelId,ExpiresAt) VALUES(@PersonId,@UserId,@RelId,( getdate() + @Duration ) )
    ELSE
      UPDATE ClinRelation SET RelId=@RelId,ExpiresAt=(getdate()+@Duration) WHERE ClinRelId=@ClinRelId
  END;
END
GO