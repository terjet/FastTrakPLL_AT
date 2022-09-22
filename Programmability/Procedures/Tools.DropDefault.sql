SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[DropDefault]( @TableName NVARCHAR(128), @ColName NVARCHAR(128) )
AS
BEGIN
  DECLARE @Command NVARCHAR(MAX)
  SELECT @Command = 'ALTER TABLE ' + @TableName + ' drop constraint ' + d.name
  FROM sys.tables t   
    JOIN sys.default_constraints d ON d.parent_object_id = t.object_id  
    JOIN sys.columns c ON c.object_id = t.object_id      
    AND c.column_id = d.parent_column_id
  WHERE t.name = @TableName
  AND c.name = @ColName;
  IF NOT @Command IS NULL EXECUTE( @Command );
END
GO