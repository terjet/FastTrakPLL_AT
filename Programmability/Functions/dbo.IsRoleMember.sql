SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[IsRoleMember]( @RoleName SYSNAME, @UserId INT ) RETURNS BIT AS
BEGIN
  DECLARE @RetVal BIT;
  IF EXISTS ( SELECT 1 FROM sys.database_role_members WHERE role_principal_id = DATABASE_PRINCIPAL_ID( @RoleName ) AND member_principal_id = @UserId )
    SET @RetVal = 1 
  ELSE 
    SET @RetVal = 0;
  RETURN @RetVal;
END
GO