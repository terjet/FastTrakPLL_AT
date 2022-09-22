SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateCaseGroup]( @StudyId INT, @PersonId INT, @GroupId INT ) AS
BEGIN
  EXEC AddStudCase @StudyId,@PersonId;
  UPDATE StudCase SET GroupId=@GroupId WHERE ( StudyId=@StudyId )  AND ( PersonId = @PersonId )
    AND ((GroupId IS NULL) OR (GroupId<>@GroupId));
END
GO

GRANT EXECUTE ON [dbo].[UpdateCaseGroup] TO [DataImport]
GO

GRANT EXECUTE ON [dbo].[UpdateCaseGroup] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateCaseGroup] TO [ReadOnly]
GO