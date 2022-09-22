SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDiagnoseMapICD10] AS
BEGIN
  SELECT mia.AnswerId,mia.OrderNumber,mia.ICD10,mi.VarName,mia.OrderNumber as EnumVal  
  FROM dbo.MetaItemAnswer mia JOIN dbo.MetaItem mi ON mi.ItemId=mia.ItemId 
  WHERE NOT mia.ICD10 IS NULL;
END
GO