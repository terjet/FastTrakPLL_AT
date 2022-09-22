SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [report].[NumericLabData] WITH SCHEMABINDING AS
  SELECT ld.PersonId, ld.LabDate, lc.LabCodeId, lc.LabName, ld.NumResult, lc.LabClassId, lcl.FriendlyName, lcl.Loinc, lcl.NLK
  FROM dbo.LabData ld 
  JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
  JOIN dbo.LabClass lcl on lcl.LabClassId = lc.LabClassId
GO