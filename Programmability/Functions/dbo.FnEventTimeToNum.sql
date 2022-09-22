﻿SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[FnEventTimeToNum]( @EventTime DateTime ) RETURNS INT
AS
BEGIN
  RETURN ROUND( CONVERT(float,@EventTime)*24+24, 0 );
END
GO

GRANT EXECUTE ON [dbo].[FnEventTimeToNum] TO [FastTrak]
GO