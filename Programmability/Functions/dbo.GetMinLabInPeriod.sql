SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetMinLabInPeriod]( @PersonId INT, @LabClassId INT, @StartAt DateTime, @StopAt DateTime ) RETURNS FLOAT
AS
BEGIN
  DECLARE @RetVal FLOAT;
  SET @RetVal = ( SELECT TOP 1 NumResult
  FROM dbo.LabData ld JOIN LabCode lc ON lc.LabCodeId=ld.LabCodeId
  WHERE ld.PersonId = @PersonId AND lc.LabClassId=@LabClassId
  AND ( ld.LabDate >= @StartAt ) AND ( ld.LabDate < @StopAt ) AND ISNULL(ld.NumResult,-1) >= 0 
  ORDER BY ld.NumResult ASC );
  RETURN @RetVal; 
END
GO

GRANT EXECUTE ON [dbo].[GetMinLabInPeriod] TO [FastTrak]
GO