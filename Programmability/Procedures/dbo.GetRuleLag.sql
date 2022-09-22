SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRuleLag]( @StudyId INT, @PersonId INT) AS
BEGIN
  SELECT ISNULL( RuleLag,0) FROM StudCase WHERE StudyId=@StudyId AND PersonId=@PersonId
END
GO

GRANT EXECUTE ON [dbo].[GetRuleLag] TO [FastTrak]
GO