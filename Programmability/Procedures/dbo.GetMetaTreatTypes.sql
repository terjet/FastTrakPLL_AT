SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMetaTreatTypes] AS
BEGIN
  SELECT TreatType,TreatDesc FROM MetaTreatType
END
GO

GRANT EXECUTE ON [dbo].[GetMetaTreatTypes] TO [FastTrak]
GO