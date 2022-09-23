SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[NdvMedianTimeInRange] AS
BEGIN
  EXEC Dash.NdvMedianInPeriod 3849, 1, 15, 5
END
GO

GRANT EXECUTE ON [Dash].[NdvMedianTimeInRange] TO [FastTrak]
GO