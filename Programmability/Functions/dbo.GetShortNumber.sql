SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetShortNumber]( @Num FLOAT ) RETURNS VARCHAR(24) AS
BEGIN
  DECLARE @RetVal VARCHAR(24);
  SET @RetVal = CONVERT(VARCHAR, @Num );
  IF ( CHARINDEX(',',@RetVal) > 0 )  OR ( CHARINDEX('.',@RetVal) > 0 )
  BEGIN
    WHILE SUBSTRING(@RetVal, LEN(@RetVal), 1 ) = '0'
      SET @RetVal = SUBSTRING(@RetVal, 1, LEN(@RetVal) - 1 );
  END
  RETURN @RetVal;
END
GO