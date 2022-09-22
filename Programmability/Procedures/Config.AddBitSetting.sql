SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Config].[AddBitSetting]( @Section VARCHAR(64), @KeyName VARCHAR(64), @BitValue BIT, @UserId INT = NULL ) AS
BEGIN
	DECLARE @SettingId INT = 0;
	SELECT @SettingId = SettingId FROM Config.Setting WHERE Section = @Section AND KeyName = @KeyName AND (ISNULL(@UserId, 0) = ISNULL(UserId, 0));

	IF @SettingId > 0
	BEGIN
		UPDATE Config.Setting SET StringValue = NULL,
			BitValue = @BitValue,
			DateValue = NULL,
			IntValue = NULL,
			DecimalValue = NULL
		WHERE SettingId = @SettingId;
	END
	ELSE
	BEGIN
		INSERT INTO Config.Setting (UserId, Section, KeyName, BitValue) VALUES (@UserId, @Section, @KeyName, @BitValue);
	END

END;
GO