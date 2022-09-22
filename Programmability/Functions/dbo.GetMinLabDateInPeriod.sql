SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetMinLabDateInPeriod]( @PersonId INT, @LabClassId INT, @StartAt DateTime, @StopAt DateTime ) RETURNS DateTime
AS
BEGIN
  DECLARE @RetVal DateTime;
  SET @RetVal = ( SELECT TOP 1 LabDate
  FROM dbo.LabData ld JOIN LabCode lc ON lc.LabCodeId=ld.LabCodeId
  WHERE ld.PersonId = @PersonId AND lc.LabClassId=@LabClassId
  AND ( ld.LabDate >= @StartAt ) AND ( ld.LabDate < @StopAt ) AND ISNULL(ld.NumResult,-1) >= 0 
  ORDER BY ld.NumResult ASC );
  RETURN @RetVal; 
END
GO

GRANT EXECUTE ON [dbo].[GetMinLabDateInPeriod] TO [FastTrak]
GO