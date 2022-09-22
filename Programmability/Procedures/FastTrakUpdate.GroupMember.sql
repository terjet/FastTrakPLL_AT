SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[GroupMember]( @XmlDoc XML) AS
BEGIN

  SET NOCOUNT ON;

  UPDATE FEST.GroupMember SET LastUpdate = '1980-01-01';

  -- Convert Xml document into a temporary table matching FEST.GroupMember

  SELECT x.r.value('@MembId', 'int') AS MembId,
    x.r.value('@GrpCode', 'varchar(7)') AS GrpCode,
    x.r.value('@GrpMember', 'varchar(7)') AS GrpMember,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/KBMetaMember/metamember') AS x (r);

  -- Merge temporary table into FEST.GroupMember on MembId as key.

  MERGE INTO FEST.GroupMember fpi USING (SELECT * FROM #temp ) xd ON (fpi.MembId = xd.MembId)

  WHEN MATCHED
    THEN UPDATE 
    SET fpi.GrpCode = xd.GrpCode,
        fpi.GrpMember = xd.GrpMember,
        fpi.LastUpdate = GETDATE()
  WHEN NOT MATCHED
    THEN 
      INSERT (MembId, GrpCode, GrpMember, LastUpdate ) 
        VALUES (xd.MembId, xd.GrpCode, xd.GrpMember, GETDATE() );

  DELETE FROM FEST.GroupMember WHERE LastUpdate = '1980-01-01';

END;
GO