SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLabCount]( @PersonId INT, @VarName VARCHAR(24),
  @StartAt DateTime, @StopAt DateTime, @NumResult DECIMAL(12,4) ) RETURNS INT
AS
BEGIN
  DECLARE @RetVal INT;
  SELECT @RetVal = COUNT(*) FROM LabData ld
    JOIN dbo.LabCode lc ON lc.LabCodeId=ld.LabCodeId AND lc.VarName=@VarName
  WHERE PersonId=@PersonId AND ( ISNULL(NumResult,-1)>=0 )
    AND ( LabDate>=@StartAt ) AND ( LabDate<@StopAt)
    AND ( (@NumResult IS NULL ) OR (NumResult=@NumResult) );
 RETURN @RetVal;
END
GO