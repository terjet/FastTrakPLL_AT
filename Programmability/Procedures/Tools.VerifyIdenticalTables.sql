SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[VerifyIdenticalTables]( @TableName SYSNAME, @SourceDb SYSNAME, @TargetDb SYSNAME ) AS 
BEGIN

  DECLARE @TrgColNames VARCHAR(MAX);
  DECLARE @SrcColNames VARCHAR(MAX);
  SELECT @TrgColNames = COALESCE(@TrgColNames + ', ', '') + [name] 
  FROM sys.syscolumns 
  WHERE id = OBJECT_ID( @TableName ) ORDER BY colorder;
  SET @SrcColNames = @TrgColNames;
  IF @TableName LIKE '%Treatment%' 
  BEGIN
    SELECT @SrcColNames = REPLACE( @SrcColNames, 'CaveIdList', 'FmCaveId AS CaveIdList' );
    SELECT @SrcColNames = REPLACE( @SrcColNames, 'Forskrivningskladd', 'Forskrivingskladd AS Forskrivningkladd' );
  END;
  IF @TableName LIKE '%Reaction%' 
  BEGIN
    SELECT @SrcColNames = REPLACE( @SrcColNames, 'CaveId', 'FMCAVEId AS CaveId' );
  END;
  PRINT 'ColNames in target: ' + @TrgColNames;
  PRINT 'ColNames in source: ' + @SrcColNames;
  DECLARE @DrugTreatmentQuery VARCHAR(MAX);
  SET @DrugTreatmentQuery = 
  CONCAT( 
  'SELECT ', @SrcColNames, ' FROM ',@SourceDb,'.', @TableName,
  ' EXCEPT  ',
  'SELECT ', @TrgColNames, ' FROM ',@TargetDb,'.', @TableName, ';' );
  DECLARE @ErrMsg VARCHAR(512);
  DECLARE @ErrLvl INT;
  DECLARE @RowCnt INT;
  PRINT 'Query: '+ @DrugTreatmentQuery;
  EXECUTE ( @DrugTreatmentQuery );
  SET @RowCnt = @@ROWCOUNT;
  IF ( @RowCnt = 0 ) 
  BEGIN
    SET @ErrMsg = CONCAT( 'The tables ', @TableName,' are perfectly identical.' );  
    SET @ErrLvl = 1;
  END
  ELSE
  BEGIN
    SET @ErrMsg = CONCAT( 'The tables ', @TableName,' have differences in ', @RowCnt, ' rows.' );  
    SET @ErrLvl = 16;
   END;
  RAISERROR( @ErrMsg, @ErrLvl, 1 );
END;

GO