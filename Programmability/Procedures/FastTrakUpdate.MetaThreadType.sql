SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaThreadType]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  SELECT 
    x.r.value('@V', 'INT') AS V,
    x.r.value('@DN', 'VARCHAR(32)') AS DN,
    x.r.value('@ThreadNames', 'VARCHAR(MAX)') AS ThreadNames,
    x.r.value('@FixedThreads', 'BIT') AS FixedThreads, 
    x.r.value('@NewThreadName', 'VARCHAR(32)') AS NewThreadName INTO #temp
  FROM @XmlDoc.nodes('/MetaThreadType/Row') AS x (r);

  -- Merge temporary table into dbo.MetaProfession on ProfType as key.

  MERGE INTO dbo.MetaThreadType mp USING (SELECT * FROM #temp ) xd ON (mp.V = xd.V)

  WHEN MATCHED
    THEN UPDATE 
    SET mp.DN = xd.DN,
        mp.ThreadNames = xd.ThreadNames,
        mp.FixedThreads = xd.FixedThreads,
        mp.NewThreadName= xd.NewThreadName
  WHEN NOT MATCHED
    THEN 
      INSERT (V, DN, ThreadNames, FixedThreads, NewThreadName ) 
        VALUES (xd.V, xd.DN, xd.ThreadNames, xd.FixedThreads, xd.NewThreadName );
END;
GO