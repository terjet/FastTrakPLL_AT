SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetImportSpec]( @FormId INT ) AS
BEGIN
  SELECT fi.OrderNumber,i.ItemId,fi.ItemText,i.ItemType,i.VarName,
  fi.MinExpression,fi.MaxExpression, MIN(ia.OrderNumber) as MinOrder, MAX(ia.OrderNumber) AS MaxOrder
  FROM dbo.MetaItem i 
  LEFT OUTER JOIN dbo.MetaItemAnswer ia ON ia.ItemId=i.ItemId 
  JOIN dbo.MetaFormItem fi ON fi.ItemId=i.ItemId 
  WHERE fi.FormId=@FormId
  GROUP BY 
    fi.OrderNumber,i.ItemId,fi.ItemText,i.ItemType,i.VarName,
    fi.MinExpression,fi.MaxExpression
  ORDER BY fi.OrderNumber
END
GO

GRANT EXECUTE ON [CRF].[GetImportSpec] TO [FastTrak]
GO