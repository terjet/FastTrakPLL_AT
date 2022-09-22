SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[SnomedCTConcept]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  SELECT 
    x.r.value('@SCTID', 'BIGINT') AS SCTID,
    x.r.value('@Term', 'VARCHAR(160)') AS Term,
    x.r.value('@NorwegianTerm', 'VARCHAR(160)') AS NorwegianTerm 
  INTO #temp
  FROM @XmlDoc.nodes('/SnomedCT.Concept/Row') AS x (r);

  -- Merge temporary table into SnomedCT.Concept using SCTID as key.

  MERGE INTO SnomedCT.Concept sct USING (SELECT * FROM #temp ) xd ON (sct.SCTID = xd.SCTID)

  WHEN MATCHED
    THEN UPDATE 
    SET sct.Term = xd.Term,
        sct.NorwegianTerm = xd.NorwegianTerm
  WHEN NOT MATCHED
    THEN 
      INSERT ( SCTID, Term, NorwegianTerm ) 
        VALUES ( xd.SCTID, xd.Term, xd.NorwegianTerm );
END
GO