SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaFormCarryException]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  -- This table can be truncated, has no foreign keys.  No need for a temporary table.

  TRUNCATE TABLE dbo.MetaFormCarryException;
  INSERT INTO dbo.MetaFormCarryException ( RowId, FormId, ItemId, EnumVal, LastUpdate )
  SELECT 
    x.r.value('@RowId', 'int') AS RowId,
    x.r.value('@FormId', 'int') AS FormId,
    x.r.value('@ItemId', 'int') AS ItemId,
    x.r.value('@EnumVal', 'int') AS EnumVal,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate
  FROM @XmlDoc.nodes('/MetaFormCarryException/Row') AS x (r);
END;
GO