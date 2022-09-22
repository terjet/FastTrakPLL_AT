SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddSchema]( @SchemaName NVARCHAR(16) )
AS
BEGIN
  DECLARE @SqlString NVARCHAR(64);
  IF SCHEMA_ID(@SchemaName) IS NULL
  BEGIN
    SET @SqlString = 'CREATE SCHEMA ' + @SchemaName + ' AUTHORIZATION dbo';
    EXEC sp_executesql @SqlString;
  END
END
GO