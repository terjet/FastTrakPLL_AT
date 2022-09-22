SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetFirstStudyGroup]( @StudyId INT, @PersonId INT ) RETURNS INT
AS
BEGIN
  DECLARE @RetVal INT;
  SELECT TOP 1 @RetVal = scl.OldGroupId FROM StudCaseLog scl JOIN StudCase sc ON sc.StudCaseId=scl.StudCaseId
  WHERE sc.StudyId=@StudyId AND sc.PersonId=@PersonId AND NOT scl.OldGroupId IS NULL
  ORDER BY ChangedAt;
  RETURN @RetVal;
END
GO