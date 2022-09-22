SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[RenameDefaultConstraint]( @FullName NVARCHAR(128), @FieldName NVARCHAR(128) )
AS
BEGIN
  DECLARE @FindName NVARCHAR(128);
  DECLARE @SchemaName NVARCHAR(128);
  DECLARE @TableName NVARCHAR(128);
  DECLARE @OldName NVARCHAR(128);
  DECLARE @NewName NVARCHAR(128);
  IF CHARINDEX( '.', @FullName ) > 0 
  BEGIN
    SET @SchemaName = SUBSTRING( @FullName,1,CHARINDEX('.',@FullName)-1);
    SET @TableName = SUBSTRING( @FullName,CHARINDEX('.',@FullName)+1, 128);
  END
  ELSE
  BEGIN
    SET @SchemaName = 'dbo';
    SET @TableName = @FullName;
  END
  SET @FindName='DF_%' + @TableName + '%_' + @FieldName + '%';
  SET @NewName = 'DF_' + @TableName + '_' + @FieldName;
  SELECT @OldName=name from sysobjects where type='D' and parent_obj=OBJECT_ID(@FullName) AND name like @FindName
  IF NOT @OldName IS NULL 
  BEGIN
    SET @OldName = @SchemaName + '.' + @OldName;
    EXEC sp_rename @OldName, @NewName;
  END
END
GO