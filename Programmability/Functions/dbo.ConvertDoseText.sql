SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ConvertDoseText]( @NumFloat FLOAT ) RETURNS VarChar(24)
AS
BEGIN
  DECLARE @RetVal VARCHAR(24);
  IF ISNULL(@NumFloat,0) = 0
    SET @RetVal = ''
  ELSE IF @NumFloat = -1  
    SET @RetVal = 'X'
  ELSE 
    SET @RetVal = CONVERT(VARCHAR,@NumFloat)
  RETURN @RetVal;
END
GO