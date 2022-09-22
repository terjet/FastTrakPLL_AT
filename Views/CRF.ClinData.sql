SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [CRF].[ClinData] AS
    SELECT 
      co.RowId,e.StudyId,e.PersonId,e.EventId,e.EventNum,e.EventTime,co.ItemId,mi.VarName,co.Quantity,co.DTVal,
      co.EnumVal,co.TextVal,co.Locked,co.ChangeCount
    FROM dbo.ClinDataPoint co
      JOIN dbo.ClinEvent e ON e.EventId=co.EventId 
      JOIN dbo.MetaItem mi ON mi.ItemId=co.ItemId
GO