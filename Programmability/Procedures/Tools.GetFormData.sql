SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[GetFormData]( @ClinFormId INT ) AS 
BEGIN
  SELECT 
    mfi.OrderNumber, 
    cdp.ItemId, mi.VarName, cdp.EnumVal, cdp.Quantity, cdp.DTVal, cdp.TextVal, 
    cdp.Locked, cdp.LockedAt, cdp.LockedBy, USER_NAME( cdp.LockedBy ) AS LockedByUser,
    ce.StudyId, ce.EventId, cdp.TouchId, cdp.RowId, cdp.ChangeCount 
  FROM dbo.ClinDataPoint cdp 
    JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
    JOIN dbo.ClinForm cf ON cf.EventId = cdp.EventId
    JOIN dbo.MetaItem mi ON mi.ItemId = cdp.ItemId
    JOIN dbo.MetaFormItem mfi ON mfi.FormId = cf.FormId AND mfi.ItemId = cdp.ItemId
  WHERE cf.ClinFormId = @ClinFormId
  ORDER BY mfi.PageNumber, mfi.OrderNumber;
END;
GO

GRANT EXECUTE ON [Tools].[GetFormData] TO [Administrator]
GO