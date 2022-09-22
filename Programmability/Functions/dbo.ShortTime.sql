SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[ShortTime]( @InputTime DateTime ) RETURNS VARCHAR(14)
AS
BEGIN
  DECLARE @StrVal varchar(14);
  DECLARE @FullFormat varchar(20);
  SET @FullFormat = CONVERT(VARCHAR,@InputTime,20)
  SET @StrVal = SUBSTRING( @FullFormat,9,2) + SUBSTRING(@FullFormat,6,2) + SUBSTRING(@FullFormat,3,2) + ' ' +
      SUBSTRING( @FullFormat,12,5); 
  RETURN @StrVal;  
END
GO