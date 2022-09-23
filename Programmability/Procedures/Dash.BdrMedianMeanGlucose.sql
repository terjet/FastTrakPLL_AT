SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[BdrMedianMeanGlucose] AS
BEGIN
  EXEC Dash.BdrMedianInPeriod 2071, 6, 6, 5
END;
GO

GRANT EXECUTE ON [Dash].[BdrMedianMeanGlucose] TO [FastTrak]
GO