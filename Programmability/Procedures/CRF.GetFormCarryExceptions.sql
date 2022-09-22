SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetFormCarryExceptions] AS
BEGIN
  SELECT FormId,ItemId,EnumVal FROM dbo.MetaFormCarryException ORDER BY FormId,ItemId,EnumVal
END
GO