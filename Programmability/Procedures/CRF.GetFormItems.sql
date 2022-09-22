SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetFormItems]( @FormId INT ) AS
BEGIN
  SELECT mfi.FormItemId, mfi.FormId, mfi.OrderNumber, mi.ItemId, mi.VarName, mi.LabName, mi.ItemType, mi.UnitStr,
    mi.MinNormal, mi.MaxNormal, mi.ThreadTypeId, mi.Multiline, mi.ProcId,
    mfi.ExcludeFromText, mfi.ExcludeFromPrint, mfi.ExcludeCaption, mfi.ItemHeader, mfi.ItemText,
    mfi.ItemHelp, mfi.Optional, mfi.ReadOnly, mfi.CarryForward,
    mfi.MinExpression, mfi.MaxExpression, mfi.Decimals, mfi.Expression, 
    mfi.FormatStr, mfi.QuantityFormatStr, mfi.Highlight,
    mfi.ClearStrategy, mfi.MaxCarryDays, 
    mfi.DefaultValue, ISNULL(mfi.Visibility, 1) AS Visibility, mfi.PageNumber, mfi.LastUpdate,
    mfi.DisplayFormat, mfi.DetailFormId
  FROM dbo.MetaFormItem mfi
  JOIN dbo.MetaItem mi ON mi.ItemId = mfi.ItemId
  LEFT OUTER JOIN dbo.MetaFormPage mfp ON mfp.PageId = mfi.PageId
  WHERE mfi.FormId = @FormId
  ORDER BY mfi.PageNumber, mfi.OrderNumber;
END;
GO

GRANT EXECUTE ON [CRF].[GetFormItems] TO [FastTrak]
GO