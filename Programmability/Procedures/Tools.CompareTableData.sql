SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[CompareTableData]( @TableName SYSNAME, @SortByField SYSNAME = NULL ) AS
BEGIN
 DECLARE @SqlStatement VARCHAR(512);
 SET @SqlStatement = CONCAT( 
 'SELECT 1 AS Src, * FROM FastTrakPLL_Test.', @TableName, 
 ' UNION',
 ' SELECT 2 AS Src, * FROM FastTrakPLL_AT.', @TableName,
 ' ORDER BY ',  ISNULL(@SortByField,'Src'), ';' );
 EXECUTE( @SqlStatement );
END
GO