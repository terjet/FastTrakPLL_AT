﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[MonthYear]( @DateValue DateTime ) RETURNS VARCHAR(MAX)
AS
BEGIN
  DECLARE @InputStr VARCHAR(MAX);
  SET @InputStr = DATENAME(mm,@DateValue) + ' ' + DATENAME(yy,@DateValue);
  RETURN UPPER(SUBSTRING(@InputStr,1,1)) + SUBSTRING(@InputStr,2,DATALENGTH(@InputStr)-1);
END
GO

GRANT EXECUTE ON [dbo].[MonthYear] TO [FastTrak]
GO