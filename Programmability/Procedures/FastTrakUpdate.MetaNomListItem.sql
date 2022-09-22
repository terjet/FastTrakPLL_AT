SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaNomListItem]( @XmlDoc XML ) AS
BEGIN
  SET NOCOUNT ON;

  SELECT x.r.value('@ListItem', 'int') AS ListItem,
    x.r.value('@ListId', 'int') AS ListId,
    x.r.value('@ItemId', 'int') AS ItemId,
    x.r.value('@IsActive', 'bit') AS IsActive
    INTO #temp
  FROM @XmlDoc.nodes('/MetaNomListItem/listitem') AS x (r);

  -- Merge temporary table into dbo.MetaForm on FormId as key.

  MERGE INTO dbo.MetaNomListItem mnli USING (SELECT * FROM #temp ) xd ON (mnli.ListItem = xd.ListItem)

  WHEN MATCHED
    THEN UPDATE 
    SET mnli.ListId = xd.ListId,
        mnli.ItemId = xd.ItemId,
        mnli.IsActive = xd.IsActive,
        mnli.LastUpdate = GETDATE()
  WHEN NOT MATCHED
    THEN 
      INSERT ( ListItem, ItemId, ListId, IsActive,  LastUpdate ) 
        VALUES ( xd.ListItem, xd.ItemId, xd.ListId, xd.IsActive, GETDATE() );
END;
GO