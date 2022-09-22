SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetItemToLabMapping] AS
BEGIN
  SELECT mi.ItemId,lc.LabClassId,lc.FriendlyName FROM dbo.MetaItem mi 
  JOIN dbo.LabClass lc ON lc.LabClassId=mi.LabClassId
END
GO