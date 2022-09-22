SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [report].[PartitionKey]( @CenterId INT = NULL ) RETURNS VARCHAR(256) AS
BEGIN
  DECLARE @RetVal VARCHAR(256);
  SET @RetVal = DEFAULT_DOMAIN() + '.' +  REPLACE( @@SERVERNAME, CHAR(92), '_' ) + '.' + DB_NAME();
  IF NOT @CenterId IS NULL SET @RetVal = @RetVal + '.' + CONVERT( VARCHAR, @CenterId );
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [report].[PartitionKey] TO [FastTrak]
GO