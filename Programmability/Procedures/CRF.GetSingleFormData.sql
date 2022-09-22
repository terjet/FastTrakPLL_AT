SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetSingleFormData]( @ClinFormId INT, @ChangedAfter DateTime = NULL ) AS
BEGIN
  IF @ChangedAfter IS NULL SET @ChangedAfter = '1980-01-01';
  SELECT 
    cdp.*, ce.EventNum, ce.EventTime, mi.VarName
  FROM dbo.ClinDataPoint cdp
    JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
    JOIN dbo.ClinForm cf ON cf.EventId = cdp.EventId
    JOIN dbo.MetaFormItem mfi ON mfi.FormId = cf.FormId AND mfi.ItemId = cdp.ItemId
    JOIN dbo.MetaItem mi ON mi.ItemId = cdp.ItemId
  WHERE ( cf.ClinFormId = @ClinFormId ) AND ( ( cdp.ObsDate > @ChangedAfter ) OR ( cdp.LockedAt > @ChangedAfter ) );
END
GO

GRANT EXECUTE ON [CRF].[GetSingleFormData] TO [FastTrak]
GO