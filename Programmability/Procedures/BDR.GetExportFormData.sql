SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetExportFormData]( @FormName VARCHAR(24), @StartAt DATETIME, @StopAt DATETIME ) AS
BEGIN
  SELECT 
    p.NationalId, 
    ce.EventTime, 
    cf.ClinFormId, cf.CreatedAt, 
    mi.ItemType, mi.VarName, 
    cdp.ItemId, cdp.EnumVal, cdp.Quantity, cdp.DTVal, cdp.TextVal
  FROM dbo.ClinForm cf
    JOIN dbo.ClinDataPoint cdp ON cdp.EventId = cf.EventId
    JOIN dbo.ClinEvent ce on ce.EventId = cf.EventId
    JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
    JOIN dbo.MetaItem mi ON mi.ItemId = cdp.ItemId
    JOIN dbo.MetaFormItem mfi ON mfi.FormId = cf.FormId AND mfi.ItemId = cdp.ItemId
    JOIN dbo.Person p ON p.PersonId = ce.PersonId AND p.TestCase = 0
  WHERE ( mf.FormName = @FormName ) AND ( DATALENGTH( p.NationalId ) = 11 ) AND ( ce.EventTime >= @StartAt ) AND ( ce.EventTime < @StopAt )
  ORDER BY p.PersonId, ce.EventNum;
END
GO

GRANT EXECUTE ON [BDR].[GetExportFormData] TO [Administrator]
GO