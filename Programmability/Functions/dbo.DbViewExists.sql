SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[DbViewExists](@SchemaName SYSNAME, @ViewName SYSNAME)
RETURNS TINYINT
AS
BEGIN
  DECLARE @RetVal TINYINT
  SELECT @RetVal = count(*)
  FROM INFORMATION_SCHEMA.VIEWS
  WHERE table_name = @ViewName
    AND table_schema = @SchemaName
  RETURN @RetVal;
END
GO