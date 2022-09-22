SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaProfession]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  SELECT 
    x.r.value('@ProfName', 'VARCHAR(32)') AS ProfName,
    x.r.value('@ProfType', 'VARCHAR(3)') AS ProfType,
    x.r.value('@ProfDescription', 'VARCHAR(MAX)') AS ProfDescription,
    x.r.value('@OID9060', 'VARCHAR(3)') AS OID9060, 
    x.r.value('@ProfLevel', 'int') AS ProfLevel INTO #temp
  FROM @XmlDoc.nodes('/MetaProfessions/MetaProfession') AS x (r);

  -- Merge temporary table into dbo.MetaProfession on ProfType as key.

  MERGE INTO dbo.MetaProfession mp USING (SELECT * FROM #temp ) xd ON (mp.ProfType = xd.ProfType)

  WHEN MATCHED
    THEN UPDATE 
    SET mp.ProfName = xd.ProfName,
        mp.ProfLevel = xd.ProfLevel,
        mp.OID9060 = xd.OID9060,
		mp.ProfDescription= xd.ProfDescription
  WHEN NOT MATCHED
    THEN 
      INSERT (ProfType, ProfName, OID9060, ProfLevel, ProfDescription ) 
        VALUES (xd.ProfType, xd.ProfName, xd.OID9060, xd.ProfLevel, xd.ProfDescription );
END;
GO