SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[BdrMedianTimeInRange] AS
BEGIN
  EXEC Dash.BdrMedianInPeriod 3849, 6, 6, 5
END;
GO

GRANT EXECUTE ON [Dash].[BdrMedianTimeInRange] TO [FastTrak]
GO