SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[RenamePrimaryKey]( @TableName NVARCHAR(128) ) AS
BEGIN
  DECLARE @PkName NVARCHAR(128);
  DECLARE @SQLCommand NVARCHAR(255);
  SELECT @PkName=name FROM sysobjects WHERE xtype='PK' AND parent_obj=OBJECT_ID(@TableName)
  SET @SQLCommand = 'EXEC sp_rename '+ @PkName + ', PK_' + @TableName;
  EXECUTE (@SQLCommand);
END
GO