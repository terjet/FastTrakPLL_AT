SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRoleMembers]( @RoleName sysname ) AS
   EXEC sp_helprolemember @RoleName
GO

GRANT EXECUTE ON [dbo].[GetRoleMembers] TO [FastTrak]
GO