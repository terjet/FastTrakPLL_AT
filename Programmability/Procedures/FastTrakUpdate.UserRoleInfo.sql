SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[UserRoleInfo]( @XmlDoc XML ) AS
BEGIN
  
  SET NOCOUNT ON;

  SELECT 
    x.r.value('@RoleName', 'SYSNAME') AS RoleName,
    x.r.value('@SortOrder', 'int') AS SortOrder,
    x.r.value('@IsActive', 'bit') AS IsActive,
    x.r.value('@RoleInfo', 'VARCHAR(MAX)') AS RoleInfo,
    x.r.value('@ProfRole', 'BIT') AS ProfRole,
    x.r.value('@RoleCaption', 'VARCHAR(24)') AS RoleCaption INTO #temp
  FROM @XmlDoc.nodes('/UserRoles/UserRole') AS x (r);

  -- Merge temporary table into dbo.UserRoleInfo on RoleName as key.

  MERGE INTO dbo.UserRoleInfo uri USING (SELECT * FROM #temp ) xd ON (uri.RoleName = xd.RoleName)

  WHEN MATCHED
    THEN UPDATE 
    SET uri.RoleCaption = xd.RoleCaption,
        uri.RoleInfo = xd.RoleInfo,
        uri.IsActive = xd.IsActive,
		uri.ProfRole = xd.ProfRole,
		uri.SortOrder = xd.SortOrder
  WHEN NOT MATCHED
    THEN 
      INSERT (RoleName, RoleCaption, RoleInfo, IsActive, SortOrder, ProfRole ) 
        VALUES (xd.RoleName, xd.RoleCaption, xd.RoleInfo, xd.IsActive, xd.SortOrder, xd.ProfRole );
END;
GO