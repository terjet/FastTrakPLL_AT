SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateUserProfession]( @UserId INT, @ProfId INT ) AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProfName VARCHAR(32);
    DECLARE @UserName VARCHAR(128);

    -- Find existing UserName and user's profession.

    SELECT @UserName = USER_NAME(@UserId);

    -- Find existing Profession for the user's BaseProfession.
    -- The BaseProfId is usually highest level if diffent from current ProfId.

    SELECT @ProfName = ProfName 
    FROM dbo.MetaProfession mp 
    JOIN dbo.UserList ul ON ul.BaseProfId = mp.ProfId 
    WHERE ul.UserId = @UserId;

    -- Remove from old profession role

    IF NOT DATABASE_PRINCIPAL_ID( @ProfName ) IS NULL
        EXEC sp_droprolemember @ProfName, @UserName;

    -- Set new profession

    UPDATE dbo.UserList SET ProfId = @ProfId, BaseProfId  = @ProfId WHERE UserId = @UserId;

    -- Find new profession name

    SELECT @ProfName = ProfName 
    FROM dbo.MetaProfession mp 
    JOIN dbo.UserList ul ON ul.BaseProfId = mp.ProfId 
    WHERE ul.UserId = @UserId;

    -- Add to new profession role if one exists for this new profession

    IF NOT DATABASE_PRINCIPAL_ID( @ProfName ) IS NULL
        EXEC sp_addrolemember @ProfName, @UserName;
END
GO

DENY EXECUTE ON [dbo].[UpdateUserProfession] TO [ReadOnly]
GO

GRANT EXECUTE ON [dbo].[UpdateUserProfession] TO [superuser]
GO