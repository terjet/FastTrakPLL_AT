SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCodeList]( @OID INT ) AS
BEGIN
  SELECT i.ItemCode,i.ItemName FROM MetaNomItem i
  JOIN MetaNomListItem li ON li.ItemId=i.ItemId
  JOIN MetaNomList l ON l.ListId=li.ListId
  WHERE l.OID = @OID 
  ORDER BY ItemCode 
END
GO