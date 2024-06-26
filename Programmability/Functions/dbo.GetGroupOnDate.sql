﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetGroupOnDate]( @PersonId INT, @StudyName VARCHAR(24), @Cutoff DateTime ) RETURNS INT
AS
BEGIN
  DECLARE @StudCaseId INT;
  DECLARE @RetVal INT;
  SELECT @StudCaseId = sc.StudCaseId FROM StudCase sc
  JOIN Study s ON s.StudyId=sc.StudyId
  WHERE sc.PersonId=@PersonId AND s.StudName=@StudyName;
  SELECT TOP 1 @RetVal = NewGroupId FROM StudCaseLog WHERE StudCaseId=@StudCaseId AND ChangedAt < @Cutoff
  ORDER BY ChangedAt DESC;
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[GetGroupOnDate] TO [FastTrak]
GO