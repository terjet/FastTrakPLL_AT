SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRoleMembers]( @RoleName sysname ) AS
   EXEC sp_helprolemember @RoleName
GO