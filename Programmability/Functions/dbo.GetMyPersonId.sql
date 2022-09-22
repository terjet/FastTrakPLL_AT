SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetMyPersonId]() RETURNS INT
AS
BEGIN
  DECLARE @PersonId INT;
  SET @PersonId = 0;
  SELECT TOP 1 @PersonId = PersonId FROM dbo.UserList WHERE UserId = USER_ID();
  RETURN @PersonId;
END
GO

GRANT EXECUTE ON [dbo].[GetMyPersonId] TO [FastTrak]
GO