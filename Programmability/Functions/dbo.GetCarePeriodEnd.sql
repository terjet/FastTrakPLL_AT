SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCarePeriodEnd]( @PersonId INTEGER, @StudyName VARCHAR(24), @SomeDate DateTime ) RETURNS DateTime
AS
BEGIN
  DECLARE @CarePeriodEnd DateTime;
  SELECT TOP 1 @CarePeriodEnd = scl.ChangedAt
  FROM StudCaseLog scl
  JOIN StudCase sc ON sc.StudCaseId=scl.StudCaseId
  JOIN Study s ON s.StudyId=sc.StudyId AND s.StudyName=@StudyName
  LEFT outer join StudyStatus ss1 ON ss1.StudyId=sc.StudyId and ss1.StatusId=scl.OldStatusId
  LEFT outer join StudyStatus ss2 ON ss2.StudyId=sc.StudyId and ss2.StatusId=scl.NewStatusId
  WHERE PersonId=@PersonId AND
   ( ss1.StatusActive=1 or scl.OldStatusId IS NULL ) AND
   ( ss2.StatusActive=0 or scl.NewStatusId IS NULL ) AND
   scl.ChangedAt > @SomeDate
  ORDER BY ChangedAt;
  RETURN @CarePeriodEnd;
END
GO