SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[DbColumnExists]( @TableName sysname, @ColumnName sysname ) RETURNS INT
AS BEGIN 
  DECLARE @ColCount INT; 
  SELECT @ColCount = count(*) from syscolumns where name=@ColumnName and  id=object_id(@TableName);
  RETURN @ColCount;
END
GO

GRANT EXECUTE ON [dbo].[DbColumnExists] TO [superuser]
GO