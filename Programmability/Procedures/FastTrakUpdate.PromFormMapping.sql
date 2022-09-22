SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[PromFormMapping]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  -- Convert Xml document into a temporary table matching PROM.FormMapping

  SELECT x.r.value('@PromId', 'int') AS PromId,
    x.r.value('@PromUid', 'VARCHAR(36)' ) AS PromUid,
    x.r.value('@FormId', 'INT') AS FormId,
    x.r.value('@ExpireDays', 'INT') AS ExpireDays,
    x.r.value('@ValidFrom', 'DateTime') AS ValidFrom,
    x.r.value('@ValidUntil', 'DateTime') AS ValidUntil
  INTO #temp
  FROM @XmlDoc.nodes('/PROM.FormMapping/Row') AS x (r);

  -- Merge temporary table into PROM.FormMapping using PromId as key.

  MERGE INTO PROM.FormMapping fm USING (SELECT t.* FROM #temp t ) xd ON (fm.PromId = xd.PromId)

  WHEN MATCHED
    THEN UPDATE 
    SET fm.PromUid = xd.PromUid,
        fm.FormId = xd.FormId,
        fm.ExpireDays = xd.ExpireDays,
        fm.ValidFrom = xd.ValidFrom,
        fm.ValidUntil = xd.ValidUntil
  WHEN NOT MATCHED
    THEN 
      INSERT (PromId, PromUid, FormId, ExpireDays, ValidFrom, ValidUntil ) 
        VALUES (xd.PromId, xd.PromUid, xd.FormId, xd.ExpireDays, xd.ValidFrom, xd.ValidUntil );
END;
GO