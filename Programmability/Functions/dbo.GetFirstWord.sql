SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetFirstWord]( @LongText VARCHAR( 1024 ) ) RETURNS VarChar(32) 
AS
BEGIN
  DECLARE @SpacePos INT;    
  DECLARE @RetVal VARCHAR(32);
  SET @RetVal = LTRIM(@LongText);
  SET @SpacePos = CHARINDEX( ' ', @RetVal );                           
  IF @SpacePos > 1 SET @RetVal = SUBSTRING( @RetVal, 1, @SpacePos-1 );
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[GetFirstWord] TO [FastTrak]
GO