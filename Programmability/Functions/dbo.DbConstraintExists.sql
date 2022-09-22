SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[DbConstraintExists]( @ConstraintName NVARCHAR(128) ) RETURNS TINYINT
AS
BEGIN
  DECLARE @RetVal TINYINT;
  SET @RetVal = 0;
  IF EXISTS( SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
    WHERE CONSTRAINT_NAME=@ConstraintName ) SET @RetVal = 1;
  IF EXISTS( SELECT * FROM sys.default_constraints
    WHERE name=@ConstraintName ) SET @RetVal = 1;
  IF EXISTS( SELECT * FROM sys.check_constraints
    WHERE name=@ConstraintName ) SET @RetVal = 1;
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[DbConstraintExists] TO [FastTrak]
GO