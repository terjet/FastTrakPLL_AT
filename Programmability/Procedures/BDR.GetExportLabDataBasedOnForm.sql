SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetExportLabDataBasedOnForm]( @Year INT ) AS
BEGIN

  SELECT p.NationalId, lda.LabDate, 
    CASE a.IsFasting WHEN 1 THEN -b.LabClassId ELSE b.LabClassId END AS LabClassId,
    b.NLK, b.LabName, b.NumResult
  FROM
  (
    SELECT ce.PersonId, cdp.ItemId, CONVERT( DATE, DTVal ) AS DateEntered,
    CASE cdp.ItemId WHEN 10570 THEN 1 ELSE 0 END AS IsFasting
    FROM dbo.ClinDataPoint cdp
      JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
      JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId
      JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = CONCAT( 'BDR_LABDATA_', @Year )
    WHERE cdp.ItemId in ( 10569, 10570 )
  ) a
  JOIN
  (
    SELECT
      ld.ResultId, ld.PersonId, lc.LabClassId, lcl.NLK, lc.LabName, CONVERT(DATE,ld.LabDate) AS LabDate, ld.NumResult
    FROM dbo.LabData ld
      JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
      JOIN dbo.LabClass lcl ON lcl.LabClassId = lc.LabClassId
    WHERE ld.NumResult > 0
      AND lc.LabClassId IN ( 34, 35, 36, 37, 44, 48, 49, 315, 316, 318, 421, 422, 507, 509, 1058, 1085, 1087, 1088 )
  ) b
  ON b.PersonId = a.PersonId AND b.LabDate = a.DateEntered
  JOIN dbo.Person p ON p.PersonId = a.PersonId AND p.TestCase = 0
  JOIN dbo.LabData lda ON lda.ResultId = b.ResultId
  ORDER BY p.NationalId, b.LabClassId, lda.LabDate;  
  
END
GO

GRANT EXECUTE ON [BDR].[GetExportLabDataBasedOnForm] TO [Administrator]
GO