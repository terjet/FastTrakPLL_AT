SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CalculateTertial]( @SomeDate DateTime, @StartsAt DateTime OUTPUT, @EndsAt DateTime OUTPUT ) AS
BEGIN
  DECLARE @m INTEGER;
  DECLARE @y INTEGER;
  SET @m = DATEPART( month, @SomeDate);   
  SET @y = DATEPART( year, @SomeDate );   
  IF @m < 5 SET @m=1 ELSE IF @m < 9 SET @m=5 ELSE SET @m = 9;
  SET @StartsAt = DATEADD(month,@m-1,DATEADD(year,@y-1900,0));
  SET @EndsAt = DATEADD(second,-1,DATEADD(month,4,@StartsAt));
END
GO

GRANT EXECUTE ON [dbo].[CalculateTertial] TO [FastTrak]
GO