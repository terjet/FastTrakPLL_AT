SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [AccessCtrl].[UserHasCaseAccess]( @UserId INT, @PersonId INT )
RETURNS BIT AS
BEGIN
  IF EXISTS (SELECT TOP 1
        uca.UserId
      FROM AccessCtrl.UserCaseBlock uca
      WHERE uca.UserId = @UserId
      AND uca.PersonId = @PersonId
      AND (uca.BlockedAt <= GETDATE()
      AND (uca.AllowedAt IS NULL
      OR uca.AllowedAt > GETDATE())))
  BEGIN
    RETURN 0;
  END;
  RETURN 1;
END
GO

GRANT EXECUTE ON [AccessCtrl].[UserHasCaseAccess] TO [FastTrak]
GO