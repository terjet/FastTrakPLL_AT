SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[DropForeignKey]( @ConstrainedTable SYSNAME, @ConstrainedColumn SYSNAME  ) AS
BEGIN
  DECLARE @RetVal INT;
  SELECT TOP 1 @RetVal = fk.object_id
  FROM sys.foreign_keys fk
  JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
  JOIN sys.all_columns ac ON ac.object_id = fk.parent_object_id  AND ac.column_id = fkc.parent_column_id
  JOIN sys.all_columns acr ON acr.object_id = fk.referenced_object_id AND acr.column_id = fkc.referenced_column_id
  WHERE fk.parent_object_id = OBJECT_ID(@ConstrainedTable) AND ac.name = @ConstrainedColumn;
  IF OBJECT_ID(@ConstrainedTable) IS NOT NULL AND @RetVal IS NOT NULL
  BEGIN
    DECLARE @SqlStatement VARCHAR(256);
    SET @SqlStatement = CONCAT ( 'ALTER TABLE ', @ConstrainedTable, ' DROP CONSTRAINT ', OBJECT_NAME(@RetVal ) ); 
    EXECUTE( @SqlStatement );
    PRINT 'The constraint was successfully removed.';
   END
  ELSE
    RAISERROR ('There is no foreign key on this table and column!', 16, 1);
END;
GO