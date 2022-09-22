SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Config].[AddDecimalSetting]( @Section VARCHAR(64), @KeyName VARCHAR(64), @DecimalValue DECIMAL(15, 5), @UserId INT = NULL ) AS
BEGIN
	DECLARE @SettingId INT = 0;
	SELECT @SettingId = SettingId FROM Config.Setting WHERE Section = @Section AND KeyName = @KeyName AND (ISNULL(@UserId, 0) = ISNULL(UserId, 0));

	IF @SettingId > 0
	BEGIN
		UPDATE Config.Setting SET StringValue = NULL,
			DateValue = NULL,
			BitValue = NULL,
			IntValue = NULL,
			DecimalValue = @DecimalValue
		WHERE SettingId = @SettingId;
	END
	ELSE
	BEGIN
		INSERT INTO Config.Setting (UserId, Section, KeyName, DecimalValue) VALUES (@UserId, @Section, @KeyName, @DecimalValue);
	END

END;
GO