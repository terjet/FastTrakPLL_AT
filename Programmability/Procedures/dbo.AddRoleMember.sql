SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddRoleMember]( @RoleName SYSNAME, @MemberName SYSNAME ) AS
BEGIN
  SET NOCOUNT ON;
  EXEC sp_addrolemember @RoleName, @MemberName;
  IF dbo.IsRoleMember( @RoleName, DATABASE_PRINCIPAL_ID( @MemberName ) ) = 1
    INSERT INTO dbo.RoleMember ( RoleName, RoleId, MemberName, MemberId ) 
    VALUES( @RoleName, DATABASE_PRINCIPAL_ID( @RoleName ), @MemberName, DATABASE_PRINCIPAL_ID( @MemberName ) )
  ELSE  
    RAISERROR( 'The membership has not been added.', 16,1 )   
END
GO

GRANT EXECUTE ON [dbo].[AddRoleMember] TO [superuser]
GO