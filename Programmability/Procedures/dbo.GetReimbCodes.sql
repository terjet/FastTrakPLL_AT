SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetReimbCodes] AS
BEGIN
  SELECT CodeId,CodeText,CodeHeader,'' AS CodeInfo FROM MetaReimbursementCode
   WHERE CodeId IN (1,2,3,4)
END
GO

GRANT EXECUTE ON [dbo].[GetReimbCodes] TO [FastTrak]
GO