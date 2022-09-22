SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DropRoleMember]( @RoleName NVARCHAR(128), @MemberName NVARCHAR(128) ) AS
BEGIN
  EXEC sp_droprolemember @RoleName, @MemberName;
  IF IS_ROLEMEMBER( @RoleName, @MemberName ) = 0
  BEGIN
    UPDATE dbo.RoleMember SET RevokedAt = GetDate(), RevokedBy=DATABASE_PRINCIPAL_ID() 
      WHERE RoleName = @RoleName AND MemberName=@MemberName AND MemberId=DATABASE_PRINCIPAL_ID(@MemberName)
      AND RevokedAt IS NULL;
    INSERT INTO dbo.RoleMember
     ( RoleName, RoleId, MemberName, MemberId, RevokedAt, RevokedBy ) 
     VALUES( @RoleName,  DATABASE_PRINCIPAL_ID(@RoleName), @MemberName, DATABASE_PRINCIPAL_ID(@MemberName),
       GetDate(), DATABASE_PRINCIPAL_ID() )
  END
  ELSE
    RAISERROR ( 'The membership still exists through an intermediate role!', 16,1 )   
END
GO

GRANT EXECUTE ON [dbo].[DropRoleMember] TO [superuser]
GO