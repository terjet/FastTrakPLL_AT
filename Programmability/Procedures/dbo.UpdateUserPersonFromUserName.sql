SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateUserPersonFromUserName]( @UserId INT ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @PersonId INT;
  SELECT @PersonId = PersonId FROM dbo.Person 
  WHERE USER_NAME(@UserId) = CONCAT(DEFAULT_DOMAIN(), '\', UserName );
  -- Update, but only for previously "unconnected" users.
  UPDATE dbo.UserList SET PersonId = @PersonId WHERE ( UserId = @UserId ) AND ( PersonId IS NULL ) AND ( NOT @PersonId IS NULL );
END;
GO