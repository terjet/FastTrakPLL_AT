SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[EnableFM] AS
BEGIN
  EXEC Config.AddBitSetting @Section = 'FM', @KeyName = 'Enabled', @BitValue = 1
END
GO