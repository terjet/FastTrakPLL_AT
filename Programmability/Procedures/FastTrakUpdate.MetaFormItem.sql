SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaFormItem]( @XmlDoc XML ) AS
BEGIN
  SET NOCOUNT ON;

  UPDATE dbo.MetaFormItem SET LastUpdate = '1980-01-01';

  SELECT 
    x.r.value('@FormItemId', 'int') AS FormItemId,
    x.r.value('@FormId', 'int') AS FormId,
    x.r.value('@ItemId', 'int') AS ItemId,
    x.r.value('@PageId', 'int') AS PageId,
    x.r.value('@PageNumber', 'int') AS PageNumber,
    x.r.value('@OrderNumber', 'int') AS OrderNumber,
    x.r.value('@ItemHeader', 'varchar(80)') AS ItemHeader,
    x.r.value('@ItemText', 'varchar(max)') AS ItemText,
    x.r.value('@ItemHelp', 'varchar(max)') AS ItemHelp,
    x.r.value('@Expression', 'varchar(max)') AS Expression,
    x.r.value('@MinExpression', 'varchar(max)') AS MinExpression,
    x.r.value('@MaxExpression', 'varchar(max)') AS MaxExpression,
    x.r.value('@Decimals', 'tinyint') AS Decimals,
    x.r.value('@CarryForward', 'tinyint') AS CarryForward,
    x.r.value('@MaxCarryDays', 'DECIMAL(8,2)') AS MaxCarryDays,
    x.r.value('@Visibility', 'int') AS Visibility,
    x.r.value('@ExcludeCaption', 'bit') AS ExcludeCaption,
    x.r.value('@ExcludeFromPrint', 'bit') AS ExcludeFromPrint,
    x.r.value('@ExcludeFromText', 'bit') AS ExcludeFromText,
    x.r.value('@Optional', 'bit') AS Optional,
    x.r.value('@ReadOnly', 'bit') AS ReadOnly,
    x.r.value('@DefaultValue', 'varchar(max)') AS DefaultValue,
    x.r.value('@FormatStr', 'varchar(48)') AS FormatStr,
    x.r.value('@DisplayFormat', 'varchar(64)') AS DisplayFormat,
    x.r.value('@Label', 'varchar(32)') AS Label,
    x.r.value('@Highlight', 'tinyint') AS Highlight,
    x.r.value('@QuantityFormatStr', 'varchar(16)') AS QuantityFormatStr,
    x.r.value('@ClearStrategy', 'tinyint') AS ClearStrategy,
    x.r.value('@DetailFormId', 'int') AS DetailFormId,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/MetaFormItem/Row') AS x (r);

  -- Merge temporary table into dbo.MetaFormItem on FormItemId as key.

  MERGE INTO dbo.MetaFormItem mfi USING (SELECT * FROM #temp ) xd ON (mfi.FormItemId = xd.FormItemId)

  WHEN MATCHED
    THEN UPDATE 
    SET mfi.FormId = xd.FormId,
        mfi.ItemId = xd.ItemId,
        mfi.OrderNumber = xd.OrderNumber,
        mfi.ItemHeader = xd.ItemHeader,
        mfi.ItemText = xd.ItemText,
        mfi.MinExpression = xd.MinExpression,
        mfi.MaxExpression = xd.MaxExpression,
        mfi.Decimals = xd.Decimals,
        mfi.Expression = xd.Expression,
        mfi.ItemHelp = xd.ItemHelp,
        mfi.CarryForward = xd.CarryForward,
        mfi.MaxCarryDays = xd.MaxCarryDays,
        mfi.ExcludeCaption = xd.ExcludeCaption,
        mfi.ExcludeFromPrint = xd.ExcludeFromPrint,
        mfi.ExcludeFromText = xd.ExcludeFromText,
        mfi.Optional = xd.Optional,
        mfi.ReadOnly = xd.ReadOnly,
        mfi.Visibility = xd.Visibility,
        mfi.PageId = xd.PageId,
        mfi.PageNumber = xd.PageNumber,
        mfi.DefaultValue = xd.DefaultValue,
        mfi.FormatStr = xd.FormatStr,
        mfi.DisplayFormat = xd.DisplayFormat,
        mfi.Label = xd.Label,
        mfi.Highlight = xd.Highlight,
        mfi.QuantityFormatStr = xd.QuantityFormatStr,
        mfi.ClearStrategy = xd.ClearStrategy,
        mfi.DetailFormId = xd.DetailFormId,
        mfi.LastUpdate = xd.LastUpdate
   WHEN NOT MATCHED
    THEN 
      INSERT ( FormItemId, FormId, ItemId, OrderNumber, ItemHeader, ItemText, MinExpression, MaxExpression, Decimals, Expression, ItemHelp, CarryForward, ExcludeCaption, ExcludeFromPrint, ExcludeFromText, 
               Optional, ReadOnly, Visibility, PageId, PageNumber, FormatStr, DisplayFormat, Label, Highlight, QuantityFormatStr, ClearStrategy, DetailFormId, MaxCarryDays, LastUpdate ) 
      VALUES ( xd.FormItemId, xd.FormId, xd.ItemId, xd.OrderNumber, xd.ItemHeader, xd.ItemText, xd.MinExpression, xd.MaxExpression, xd.Decimals, xd.Expression, xd.ItemHelp, xd.CarryForward, xd.ExcludeCaption, xd.ExcludeFromPrint, xd.ExcludeFromText, 
               xd.Optional, xd.ReadOnly, xd.Visibility,xd.PageId,xd.PageNumber,xd.FormatStr, xd.DisplayFormat, xd.Label, xd.Highlight, xd.QuantityFormatStr, xd.ClearStrategy, xd.DetailFormId, xd.MaxCarryDays, xd.LastUpdate );

 DELETE FROM  dbo.MetaFormItem WHERE LastUpdate = '1980-01-01';

END;
GO