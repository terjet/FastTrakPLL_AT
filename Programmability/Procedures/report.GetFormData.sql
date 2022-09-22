SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetFormData]( @PersonId INT, @FormName VARCHAR(32) ) AS
BEGIN
  -- Retrieve data actually registered on specific form with latest data first
  -- The date conversion in DATEDIFF makes the quantity compatible with Excel dates.
  -- Excel has a bug for the year 1900, See https://www.joelonsoftware.com/2006/06/16/my-first-billg-review/.
  SELECT a.* FROM
  (
    SELECT ce.PersonId, mi.VarName, ISNULL(dp.Quantity, DATEDIFF(DD,'1899-12-30',dp.DTVal)) AS Quantity, ce.EventTime, dp.RowId,
      RANK() OVER ( PARTITION BY mi.ItemId ORDER BY ce.EventTime, dp.RowId DESC ) AS OrderBy 
    FROM dbo.ClinDatapoint dp 
      JOIN dbo.ClinEvent ce ON ce.EventId = dp.EventId
      JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId
      JOIN dbo.MetaItem mi ON mi.ItemId = dp.ItemId
      JOIN dbo.MetaFormItem mfi ON mfi.FormId = cf.FormId AND mfi.ItemId = mi.ItemId
      JOIN dbo.MetaForm mf ON mf.FormId = mfi.FormId 
    WHERE mf.FormName = @FormName AND ce.PersonId = @PersonId
  ) a
  WHERE a.OrderBy = 1;
END
GO

GRANT EXECUTE ON [report].[GetFormData] TO [superuser]
GO