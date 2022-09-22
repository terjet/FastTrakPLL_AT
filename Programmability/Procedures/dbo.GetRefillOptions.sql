SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRefillOptions] AS
BEGIN
  SELECT Refills,RefillText FROM MetaRefillText ORDER BY Refills
END
GO

GRANT EXECUTE ON [dbo].[GetRefillOptions] TO [FastTrak]
GO