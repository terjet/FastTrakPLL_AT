SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaNomList]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  SELECT x.r.value('@ListId', 'int') AS ListId,
    x.r.value('@ListName', 'varchar(32)') AS ListName,
    x.r.value('@ListActive', 'int') AS ListActive,
    x.r.value('@ListVersion', 'int') AS ListVersion,
    x.r.value('@LCID', 'int') AS LCID,
    x.r.value('@DxSystem', 'int') AS DxSystem,
    x.r.value('@OID', 'int') AS OID
	INTO #temp
  FROM @XmlDoc.nodes('/MetaNomList/list') AS x (r);

  -- Merge temporary table into dbo.MetaNOmList on ListId as key.

  MERGE INTO dbo.MetaNomList mf USING (SELECT * FROM #temp ) xd ON (mf.ListId = xd.ListId)

  WHEN MATCHED
    THEN UPDATE 
    SET mf.ListName = xd.ListName,
        mf.ListActive = xd.ListActive,
		mf.ListVersion = xd.ListVersion,
		mf.LCID = xd.LCID,
		mf.DxSystem = xd.DxSystem,
		mf.OID = xd.OID,
		mf.LastUpdate = GETDATE()
  WHEN NOT MATCHED
    THEN 
      INSERT ( ListId, ListName, ListActive, ListVersion, LCID, DxSystem, OID, LastUpdate) 
        VALUES ( xd.ListId, xd.ListName, xd.ListActive, xd.ListVersion, xd.LCID, xd.DxSystem, xd.OID, GETDATE());
END;
GO