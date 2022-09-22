SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [CRF].[GetStatusOnDate]( @PersonId INT, @StudyName VARCHAR(24), @Cutoff DATETIME, @NewerIfNull INT = 0) 
 RETURNS INT
AS
BEGIN
  DECLARE @StudCaseId INT ;
  DECLARE @RetVal INT ;

  SELECT @StudCaseId = sc.StudCaseId 
    FROM StudCase sc
	     JOIN Study s ON s.StudyId=sc.StudyId
   WHERE sc.PersonId=@PersonId AND s.StudName=@StudyName;

  SELECT TOP 1 @RetVal = NewStatusId 
    FROM StudCaseLog 
   WHERE StudCaseId=@StudCaseId AND ChangedAt < @Cutoff
  ORDER BY ChangedAt DESC;

  IF (@NewerIfNull = 1 AND @RetVal IS NULL) 
	  SELECT TOP 1 @RetVal = NewStatusId 
	    FROM StudCaseLog 
	   WHERE StudCaseId=@StudCaseId AND ChangedAt >= @Cutoff
	ORDER BY ChangedAt ASC;
  
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [CRF].[GetStatusOnDate] TO [Administrator]
GO