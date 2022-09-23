SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[BdrMedianTimeBelowRange] AS
BEGIN
  EXEC Dash.BdrMedianInPeriod 10959, 6, 6, 5
END;
GO

GRANT EXECUTE ON [Dash].[BdrMedianTimeBelowRange] TO [FastTrak]
GO