SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ExpireRelations]( @PersonId INT, @UserId INT = NULL ) AS
BEGIN
  IF @UserId IS NULL SET @UserId = USER_ID();
  UPDATE ClinRelation SET ExpiresAt=getdate() WHERE PersonId=@PersonId AND UserId=@UserId;
END;
GO

GRANT EXECUTE ON [dbo].[ExpireRelations] TO [FastTrak]
GO