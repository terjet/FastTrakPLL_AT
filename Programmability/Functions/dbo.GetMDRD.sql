SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetMDRD] (@PersonId INT, @CalcAt DATETIME)
RETURNS DECIMAL(9, 1) AS
BEGIN
  -- IDMS-Traceable MDRD Study Equation
  DECLARE @Age FLOAT;
  DECLARE @Sex INT;
  DECLARE @Creat FLOAT;
  DECLARE @k FLOAT;
  DECLARE @GFR FLOAT;
  DECLARE @BSA FLOAT;
  /* Find age for person at time @CalcAt */
  SELECT @Age = CONVERT(FLOAT, @CalcAt - DOB) / 365.25
  FROM Person
  WHERE PersonId = @PersonId;
  SELECT @Sex = GenderId
  FROM Person
  WHERE PersonId = @PersonId;
  /* Set up constants for sex male/female */
  IF @Sex = 2
    SET @k = 0.742
  ELSE
    SET @k = 1.0;
  SET @Creat = dbo.GetLastLabInPeriod(@PersonId, 49, 0, @CalcAt);
  /* Calculate GFR if everything is good, make sure @Creat is not too low */
  IF ((@Creat IS NULL)
    OR (@Age IS NULL)
    OR (@Creat < 10.0))
    SET @GFR = NULL
  ELSE
    SET @GFR = 175 * POWER(@Creat / 88.4, -1.154) * POWER(@Age, -0.203) * @k;
  RETURN @GFR;
END
GO