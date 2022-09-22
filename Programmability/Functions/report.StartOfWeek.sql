SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [report].[StartOfWeek]( @SomeDate DateTime ) RETURNS DateTime AS
BEGIN 
  RETURN DATEADD( WEEK, DATEDIFF( WEEK, 0, @SomeDate ), 0 )
END
GO

GRANT EXECUTE ON [report].[StartOfWeek] TO [FastTrak]
GO