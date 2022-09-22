SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [GBD].[Tvangsvedtak] AS
  SELECT ce.StudyId, ce.PersonId, ce.EventTime, cpstart.DTVal AS StartDate, cpstop.DTVal AS StopDate,
    ISNULL(cpaction.EnumVal, 1) AS StopAction, CONVERT(INT, getdate() - cpstop.DTVal) AS DaysPastDue,
    cf.ClinFormId
  FROM dbo.ClinEvent ce
  JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName IN ( 'TVANGSVEDTAK', 'TVANGSVEDTAKv2' )
  LEFT JOIN dbo.ClinDatapoint cpstart ON cpstart.EventId = ce.EventId AND cpstart.ItemId = 4496 
  LEFT JOIN dbo.ClinDatapoint cpstop ON cpstop.EventId = ce.EventId AND cpstop.ItemId = 4497 
  LEFT JOIN dbo.ClinDatapoint cpaction ON cpaction.EventId = ce.EventId AND cpaction.ItemId = 6888
GO

GRANT SELECT ON [GBD].[Tvangsvedtak] TO [FastTrak]
GO