SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[PromFieldMapping]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  -- Convert Xml document into a temporary table matching PROM.FieldMapping

  SELECT 
    x.r.value('@PromId', 'INT' ) AS PromId,
    x.r.value('@FieldName', 'VARCHAR(64)') AS FieldName,
    x.r.value('@ItemId', 'INT') AS ItemId
  INTO #temp
  FROM @XmlDoc.nodes('/PROM.FieldMapping/Row') AS x (r);

  -- Merge temporary table into PROM.FieldMapping on RowId as key.

  MERGE INTO PROM.FieldMapping fm USING (SELECT t.* FROM #temp t ) xd ON (fm.PromId = xd.PromId AND fm.FieldName=xd.FieldName)

  WHEN MATCHED
    THEN UPDATE 
    SET fm.ItemId = xd.ItemId
  WHEN NOT MATCHED
    THEN 
      INSERT (PromId, FieldName, ItemId ) 
        VALUES (xd.PromId, xd.FieldName, xd.ItemId );
END;
GO