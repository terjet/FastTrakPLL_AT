SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Config].[DeleteSetting]( @Section VARCHAR(64), @KeyName VARCHAR(64), @UserId INT = NULL ) AS
BEGIN
	DELETE FROM Config.Setting
	WHERE Section = @Section
		AND KeyName = @KeyName
		AND ISNULL(UserId, 0) = ISNULL(@UserId, 0);
END
GO