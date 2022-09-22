SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetLastLab]( @PersonId INT, @VarName VARCHAR(24) ) RETURNS FLOAT
AS
BEGIN
  DECLARE @RetVal FLOAT;
  SET @RetVal = ( SELECT TOP 1 ld.NumResult
    FROM LabData ld JOIN LabCode lc ON ( lc.labCodeId=ld.LabCodeId ) AND ( VarName=@VarName )
    WHERE ( PersonId=@PersonId ) AND ( ISNULL(NumResult,-1) <> -1 )
    ORDER BY ld.LabDate DESC )
 RETURN @RetVal;
END
GO