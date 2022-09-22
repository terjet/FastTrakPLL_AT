﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Config].[GetBitSetting]( @Section VARCHAR(64), @KeyName VARCHAR(64), @UserId INT = NULL ) AS
BEGIN
	DECLARE @Value BIT = NULL;
	DECLARE @Result BIT = 0;

	SELECT @Value = BitValue, @Result = 1 FROM Config.Setting WHERE (ISNULL(@UserId, 0) = ISNULL(UserId, 0)) AND Section = @Section AND KeyName = @KeyName;

	IF @Result = 0
		SELECT @Value = BitValue, @Result = 1 FROM Config.Setting WHERE UserId IS NULL AND Section = @Section AND KeyName = @KeyName;

	SELECT @Result AS Result, @Value AS KeyValue
END;
GO