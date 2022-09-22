SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastEvent]( @PersonId INT, @StudyName VARCHAR(24) ) RETURNS DateTime
AS
BEGIN
  DECLARE @RetVal DateTime;
  select @RetVal = max(ce.EventTime) FROM ClinEvent ce join Study s ON s.StudyId = ce.StudyId
  AND s.StudyName = @StudyName
  WHERE PersonId = @PersonId;
  RETURN @RetVal;
END
GO