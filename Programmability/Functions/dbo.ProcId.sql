SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ProcId]( @ProcName VARCHAR(64) ) RETURNS INT AS
BEGIN
  DECLARE @RetVal INT;
  SELECT @RetVal=id FROM sysobjects where xtype='P' AND name=@ProcName;
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[ProcId] TO [FastTrak]
GO