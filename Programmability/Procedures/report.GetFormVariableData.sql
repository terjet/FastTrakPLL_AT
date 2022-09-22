SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetFormVariableData]( @PersonId INT, @FormName VARCHAR(32) ) AS
BEGIN
  SET NOCOUNT ON;
  -- Retrieve variables that appear on specific form with latest data first
  SELECT a.* FROM 
  (
    SELECT ce.PersonId,mi.VarName,dp.Quantity,ce.EventTime,dp.RowId,
       RANK() OVER ( PARTITION BY mi.ItemId ORDER BY ce.EventTime DESC, dp.RowId DESC ) AS OrderBy
    FROM dbo.ClinDatapoint dp 
      JOIN dbo.ClinEvent ce ON ce.EventId = dp.EventId
      JOIN dbo.MetaFormItem mfi ON mfi.ItemId = dp.ItemId
      JOIN dbo.MetaForm mf ON mf.FormId = mfi.FormId 
      JOIN dbo.MetaItem mi ON mi.ItemId = dp.ItemId
    WHERE mf.FormName = @FormName AND ce.PersonId = @PersonId
   ) a
   WHERE a.OrderBy = 1;
END
GO

GRANT EXECUTE ON [report].[GetFormVariableData] TO [FastTrak]
GO