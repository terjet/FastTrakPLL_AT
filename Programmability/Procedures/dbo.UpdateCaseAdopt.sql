SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateCaseAdopt]( @StudyId INT, @PersonId INT ) AS
BEGIN
  UPDATE StudCase SET HandledBy = user_id() 
    WHERE StudyId=@StudyId AND PersonId=@PersonId AND HandledBy<>user_id()
END
GO

GRANT EXECUTE ON [dbo].[UpdateCaseAdopt] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateCaseAdopt] TO [ReadOnly]
GO