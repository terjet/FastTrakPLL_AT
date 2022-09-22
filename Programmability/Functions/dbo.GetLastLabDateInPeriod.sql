SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastLabDateInPeriod]( @PersonId INT, @LabClassId INT, @StartAt DateTime, @StopAt DateTime ) RETURNS DateTime
AS
BEGIN
  DECLARE @RetVal DateTime;
  SET @RetVal = ( SELECT TOP 1 LabDate
  FROM dbo.LabData ld JOIN LabCode lc ON lc.LabCodeId=ld.LabCodeId
  WHERE ld.PersonId = @PersonId AND lc.LabClassId=@LabClassId
  AND ( ld.LabDate >= @StartAt ) AND ( ld.LabDate < @StopAt ) AND ISNULL(ld.NumResult,-1) >= 0 
  ORDER BY ld.LabDate DESC );
  RETURN @RetVal; 
END
GO