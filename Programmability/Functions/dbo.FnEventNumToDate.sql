SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnEventNumToDate]( @EventNum INT ) RETURNS DateTime
AS
BEGIN
  DECLARE @RetVal DateTime;
  SET @RetVal = convert(datetime,(convert(float,(@EventNum - 24)) / 24 + 0.00000002));
  RETURN @RetVal
END
GO

GRANT EXECUTE ON [dbo].[FnEventNumToDate] TO [FastTrak]
GO