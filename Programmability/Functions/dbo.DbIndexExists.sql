SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[DbIndexExists]( @TableName NVARCHAR(128), @IndexName NVARCHAR(128) ) RETURNS TINYINT
AS
BEGIN
  DECLARE @RetVal TINYINT;
  IF INDEXPROPERTY(OBJECT_ID(@TableName) , @IndexName , 'IndexID' ) IS NULL
    SET @RetVal = 0
  ELSE
    SET @RetVal = 1;
  RETURN @RetVal
END;
GO

GRANT EXECUTE ON [dbo].[DbIndexExists] TO [FastTrak]
GO