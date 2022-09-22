SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaItem]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;
  
  SELECT x.r.value('@ItemId', 'INT') AS ItemId,
    x.r.value('@VarName', 'VARCHAR(64)') AS VarName,
    x.r.value('@ItemType', 'INT') AS ItemType,
    x.r.value('@UnitStr', 'VARCHAR(16)') AS UnitStr,
    x.r.value('@MinNormal', 'DECIMAL(12,2)') AS MinNormal,
    x.r.value('@MaxNormal', 'DECIMAL(12,2)') AS MaxNormal,
    x.r.value('@ThreadTypeId', 'INT') AS ThreadTypeId,
    x.r.value('@LabName', 'VARCHAR(40)') AS LabName,
    x.r.value('@Multiline', 'BIT') AS Multiline,
    x.r.value('@ProcId', 'INT') AS ProcId,
    x.r.value('@SCTID', 'BIGINT') AS SCTID,
    x.r.value('@ValidationPattern', 'VARCHAR(64)' ) AS ValidationPattern,
    x.r.value('@LastUpdate', 'DATETIME') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/MetaItem/Row') AS x (r);

  -- Merge temporary table into dbo.MetaItem on ItemId as key.

  MERGE INTO dbo.MetaItem mf USING (SELECT * FROM #temp ) xd ON (mf.ItemId = xd.ItemId)

  WHEN MATCHED
    THEN UPDATE 
    SET mf.VarName = xd.VarName,
        mf.ItemType = xd.ItemType,
        mf.UnitStr = xd.UnitStr,
        mf.MinNormal = xd.MinNormal,
        mf.MaxNormal = xd.MaxNormal,
        mf.ThreadTypeId = xd.ThreadTypeId,
        mf.LabName = xd.LabName,
        mf.Multiline = xd.Multiline,
        mf.ProcId = xd.ProcId,
        mf.SCTID = xd.SCTID,
        mf.ValidationPattern = xd.ValidationPattern,
        mf.LastUpdate = xd.LastUpdate
  WHEN NOT MATCHED
    THEN INSERT ( ItemId, VarName, ItemType, UnitStr, MinNormal, MaxNormal, ThreadTypeId, LabName, Multiline, ProcId, SCTID, ValidationPattern, LastUpdate ) 
      VALUES ( xd.ItemId, xd.VarName, xd.ItemType, xd.UnitStr, xd.MinNormal, xd.MaxNormal, xd.ThreadTypeId, xd.LabName, xd.Multiline, xd.ProcId, xd.SCTID, xd.ValidationPattern, xd.LastUpdate );
END;
GO