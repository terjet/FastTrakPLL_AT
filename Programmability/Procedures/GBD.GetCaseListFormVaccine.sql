SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListFormVaccine]( @StudyId INT ) AS
BEGIN
  SELECT v.*,
    CONCAT(
    CASE WHEN cdp1.ItemId IS NOT NULL THEN REPLACE(cdp1.ItemId, 7051, 'Pneumokokk') END,
    IIF( cdp1.ItemId IS NULL OR cdp2.ItemId IS NULL, '', ' + ' ),
    CASE WHEN cdp2.ItemId IS NOT NULL THEN REPLACE(cdp2.ItemId, 7052, 'Influensa') END,
    IIF( cdp2.ItemId IS NULL OR cdp3.ItemId IS NULL, '', ' + ' ),
    IIF( cdp2.ItemId IS NULL AND NOT ( cdp1.ItemId+cdp3.ItemId IS NULL ), ' + ', '' ),
    CASE WHEN cdp3.ItemId IS NOT NULL THEN REPLACE(cdp3.ItemId, 11112, 'Covid-19') END,
    ' gitt ' + CONVERT(VARCHAR, frm.EventTime, 104), '.' ) AS InfoText
  FROM dbo.GetLastFormTableByName('GbdVaksine', GETDATE() + 1) frm
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = frm.PersonId
  LEFT JOIN dbo.ClinDataPoint cdp1 ON cdp1.EventId = frm.EventId AND cdp1.ItemId = 7051 AND cdp1.EnumVal = 1
  LEFT JOIN dbo.ClinDataPoint cdp2 ON cdp2.EventId = frm.EventId AND cdp2.ItemId = 7052 AND cdp2.EnumVal = 1
  LEFT JOIN dbo.ClinDataPoint cdp3 ON cdp3.EventId = frm.EventId AND cdp3.ItemId = 11112 AND cdp3.EnumVal = 1
  WHERE v.StudyId = @StudyId 
    AND ( cdp1.EnumVal = 1 OR cdp2.EnumVal = 1 OR cdp3.EnumVal = 1 );
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListFormVaccine] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFormVaccine] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFormVaccine] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFormVaccine] TO [Vernepleier]
GO