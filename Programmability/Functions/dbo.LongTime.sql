SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[LongTime]( @InputTime DateTime ) RETURNS VARCHAR(20)
AS
BEGIN
  DECLARE @StrVal varchar(20);
  SET @StrVal = CONVERT(VARCHAR,@InputTime,4) + ' kl ' + SUBSTRING( CONVERT(VARCHAR,@InputTime,8), 1, 5 );
  RETURN @StrVal;
END
GO

GRANT EXECUTE ON [dbo].[LongTime] TO [FastTrak]
GO