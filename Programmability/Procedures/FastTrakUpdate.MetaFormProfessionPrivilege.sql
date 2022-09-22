SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaFormProfessionPrivilege]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  -- This table can be truncated, has no foreign keys.  No need for a temporary table.

  TRUNCATE TABLE dbo.MetaFormProfessionPrivilege;
  INSERT INTO dbo.MetaFormProfessionPrivilege ( RowId, FormId, ProfType, CanCreate, CanEdit, CanSign, Comment, LastUpdate )
  SELECT 
    x.r.value('@RowId', 'int') AS RowId,
    x.r.value('@FormId', 'int') AS FormId,
    x.r.value('@ProfType', 'VARCHAR(3)') AS ProfType,
    x.r.value('@CanCreate', 'bit') AS CanCreate,
    x.r.value('@CanEdit', 'bit') AS CanEdit,
    x.r.value('@CanSign', 'bit') AS CanSign,
    x.r.value('@Comment', 'varchar(max)') AS Comment,
    x.r.value('@LastUpdate', 'DateTime') AS LastUpdate
  FROM @XmlDoc.nodes('/MetaFormProfessionPrivilege/Row') AS x (r);
END;
GO