SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaNomItem]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  SELECT x.r.value('@ItemId', 'int') AS ItemId,
    x.r.value('@ItemCode', 'varchar(8)') AS ItemCode,
    x.r.value('@ItemName', 'varchar(max)') AS ItemName
	INTO #temp
  FROM @XmlDoc.nodes('/MetaNomItem/item') AS x (r);

  -- Merge temporary table into dbo.MetaNomItem on ItemId as key.

  MERGE INTO dbo.MetaNomItem mf USING (SELECT * FROM #temp ) xd ON (mf.ItemId = xd.ItemId)

  WHEN MATCHED
    THEN UPDATE 
    SET mf.ItemCode = xd.ItemCode,
        mf.ItemName = xd.ItemName,
		mf.LastUpdate = GETDATE()
  WHEN NOT MATCHED
    THEN 
      INSERT ( ItemId, ItemCode, ItemName, LastUpdate) 
        VALUES ( xd.ItemId, xd.ItemCode, xd.ItemName, GETDATE());
END;
GO