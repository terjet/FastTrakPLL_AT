SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastLabInThePast]( @PersonId INT, @VarName VARCHAR(24), @CutoffTime DateTime = NULL ) RETURNS FLOAT
AS
BEGIN
  DECLARE @RetVal FLOAT;
  IF @CutoffTime IS NULL SET @CutoffTime = getdate();
  SET @RetVal = ( SELECT TOP 1 ld.NumResult
    FROM LabData ld JOIN LabCode lc ON ( lc.labCodeId=ld.LabCodeId ) AND ( VarName=@VarName )
    WHERE ( PersonId=@PersonId ) AND ( ISNULL(NumResult,-1) <> -1 ) AND ( ld.LabDate < @CutoffTime )
    ORDER BY ld.LabDate DESC )
 RETURN @RetVal;
END
GO