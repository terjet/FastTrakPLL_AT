﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateUserPerson]( @UserId INT, @PersonId INT ) AS
BEGIN
  UPDATE UserList SET PersonId=@PersonId WHERE UserId=@UserId;
END
GO

DENY EXECUTE ON [dbo].[UpdateUserPerson] TO [ReadOnly]
GO

GRANT EXECUTE ON [dbo].[UpdateUserPerson] TO [superuser]
GO