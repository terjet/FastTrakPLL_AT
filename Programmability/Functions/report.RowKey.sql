﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [report].[RowKey]( @TimeAxis DateTime ) RETURNS VARCHAR(10) AS
BEGIN
  RETURN CONVERT( VARCHAR, @TimeAxis, 112 );
END
GO

GRANT EXECUTE ON [report].[RowKey] TO [FastTrak]
GO