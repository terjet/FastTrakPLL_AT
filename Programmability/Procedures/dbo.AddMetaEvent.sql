SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddMetaEvent]( @EventTyp INT, @EventName VARCHAR(32) )
AS
BEGIN
  PRINT 'Not implemented';
END
GO

GRANT EXECUTE ON [dbo].[AddMetaEvent] TO [FastTrak]
GO