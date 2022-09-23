SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[ReportLabData2020]( @PersonId INT, @FormId INT ) AS
BEGIN
  CREATE TABLE #SortOrder (LabClassId INT, SortOrder INT);
  INSERT INTO #SortOrder VALUES (34, 1);
  INSERT INTO #SortOrder VALUES (37, 2);
  INSERT INTO #SortOrder VALUES (35, 3);
  INSERT INTO #SortOrder VALUES (36, 4);
  INSERT INTO #SortOrder VALUES (509, 5);
  INSERT INTO #SortOrder VALUES (507, 6);

  SELECT * FROM
  (
    -- Første prøver
    SELECT cl.NLK, lc.labName, cl.LabClassId, ld.LabDate, ld.NumResult, ld.UnitStr, ld.InvestigationId, ld.ResultId, 'Blodprøver' AS GroupText
      FROM dbo.ClinForm cf 
      JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId AND ce.PersonId = @PersonId
      JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId and cdp.ItemId = 10569
      JOIN dbo.LabData ld ON ld.PersonId = ce.PersonId and CONVERT(DATE,ld.LabDate) = cdp.DTVal
      JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
      JOIN dbo.LabClass cl ON cl.LabClassId = lc.LabClassId
      WHERE FormId = @FormId AND lc.LabClassId IN (34,35,36,37,39,507,509,574)
    UNION
    -- Kontrollprøver
    SELECT cl.NLK, lc.labName, cl.LabClassId, ld.LabDate, ld.NumResult, ld.UnitStr, ld.InvestigationId, ld.ResultId, 'Kontrollprøver'
      FROM dbo.ClinForm cf 
      JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId AND ce.PersonId = @PersonId
      JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId and cdp.ItemId = 10570
      JOIN dbo.LabData ld ON ld.PersonId = ce.PersonId and CONVERT(DATE,ld.LabDate) = cdp.DTVal
      JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
      JOIN dbo.LabClass cl ON cl.LabClassId = lc.LabClassId
      WHERE FormId = @FormId AND lc.LabClassId IN (34,35,36,37,39,507,509,574)
  ) agg
  ORDER BY GroupText, (SELECT SortOrder from #SortOrder so WHERE so.LabClassId = agg.LabClassId);
END
GO

GRANT EXECUTE ON [BDR].[ReportLabData2020] TO [FastTrak]
GO