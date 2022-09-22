SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetFirstStudyStatus]( @StudyId INT, @PersonId INT ) RETURNS INT
AS
BEGIN
  DECLARE @RetVal INT;
  SELECT TOP 1 @RetVal = scl.OldStatusId FROM StudCaseLog scl JOIN StudCase sc ON sc.StudCaseId=scl.StudCaseId
  WHERE sc.StudyId=@StudyId AND sc.PersonId=@PersonId AND NOT scl.OldStatusId IS NULL
  ORDER BY ChangedAt;
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[GetFirstStudyStatus] TO [FastTrak]
GO