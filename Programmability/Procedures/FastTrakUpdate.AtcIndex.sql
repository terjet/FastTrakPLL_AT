SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[AtcIndex]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  UPDATE FEST.AtcIndex SET LastUpdate = '1980-01-01';

  -- Convert Xml document into a temporary table matching FEST.AtcIndex

  SELECT x.r.value('@AtcId', 'int') AS AtcId,
    x.r.value('@AtcCode', 'varchar(7)') AS AtcCode,
    x.r.value('@AtcName', 'varchar(80)') AS AtcName,
    x.r.value('@AtcMaintained', 'tinyint') AS AtcMaintained,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/KBAtcIndex/atc') AS x (r);

  -- Merge temporary table into FEST.AtcIndex on AtcId as key.

  MERGE INTO FEST.AtcIndex fpi USING (SELECT * FROM #temp ) xd ON (fpi.AtcId = xd.AtcId)

  WHEN MATCHED
    THEN UPDATE 
    SET fpi.AtcCode = xd.AtcCode,
        fpi.AtcName = xd.AtcName,
        fpi.AtcMaintained = xd.AtcMaintained,
        fpi.LastUpdate = GETDATE()
  WHEN NOT MATCHED
    THEN 
      INSERT (AtcId, AtcCode, AtcName, AtcMaintained, LastUpdate ) 
        VALUES (xd.AtcId, xd.AtcCode, xd.AtcName, xd.AtcMaintained, GETDATE() );

  DELETE FROM FEST.AtcIndex WHERE LastUpdate = '1980-01-01';

END;
GO