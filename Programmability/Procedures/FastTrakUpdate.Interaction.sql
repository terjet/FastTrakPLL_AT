SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[Interaction]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  UPDATE FEST.Interaction SET LastUpdate = '1980-01-01';

  -- Convert Xml document into a temporary table matching FEST.Interaction

  SELECT x.r.value('@IntId', 'int') AS IntId,
    x.r.value('@ATC1', 'varchar(7)') AS ATC1,
    x.r.value('@ATC2', 'varchar(7)') AS ATC2,
    x.r.value('@LevelId', 'int') AS LevelId,
    x.r.value('@InfoText', 'varchar(512)') AS InfoText,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/KBInteraction/interaction') AS x (r);

  -- Merge temporary table into FEST.Interaction on IntId as key.

  MERGE INTO FEST.Interaction fpi USING (SELECT * FROM #temp ) xd ON (fpi.IntId = xd.IntId)

  WHEN MATCHED
    THEN UPDATE 
    SET fpi.ATC1 = xd.ATC1,
        fpi.ATC2 = xd.ATC2,
        fpi.LevelId = xd.LevelId,
        fpi.InfoText = xd.InfoText,
        fpi.LastUpdate = GETDATE()
  WHEN NOT MATCHED
    THEN 
      INSERT (IntId, ATC1, ATC2, LevelId, InfoText, LastUpdate ) 
        VALUES (xd.IntId, xd.ATC1, xd.ATC2, xd.LevelId, xd.InfoText, GETDATE() );

  DELETE FROM FEST.Interaction WHERE LastUpdate = '1980-01-01';

END;
GO