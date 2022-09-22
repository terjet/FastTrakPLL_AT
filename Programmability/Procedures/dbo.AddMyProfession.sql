SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddMyProfession]( @ProfId INT ) AS
BEGIN
	SET NOCOUNT ON
	UPDATE dbo.UserList
	SET ProfId = @ProfId, BaseProfId = @ProfId
	WHERE UserId = USER_ID()
	AND ProfId IS NULL
END
GO