SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ConvertDoseHourText]( @NumFloat FLOAT, @ThisHour TINYINT, @DoseHour TinyInt ) RETURNS VarChar(24)
AS
BEGIN
  DECLARE @RetVal VARCHAR(24);
  IF ISNULL(@NumFloat,0) = 0 
  BEGIN
    IF @ThisHour=@DoseHour
      SET @RetVal = 'U'
    ELSE 
      SET @RetVal = '';
  END
  ELSE IF @NumFloat = -1
    SET @RetVal = 'X'
  ELSE
    SET @RetVal = CONVERT(VARCHAR,@NumFloat)
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[ConvertDoseHourText] TO [FastTrak]
GO