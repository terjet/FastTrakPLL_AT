﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[NdvType1HbA1cBelow52] AS
BEGIN
  EXEC Dash.NdvType1HbA1cBelow 52, 15, 4;
END
GO

GRANT EXECUTE ON [Dash].[NdvType1HbA1cBelow52] TO [FastTrak]
GO