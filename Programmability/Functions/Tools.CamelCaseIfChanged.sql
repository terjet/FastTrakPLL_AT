﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [Tools].[CamelCaseIfChanged] (@OldValue VARCHAR(MAX), @NewValue VARCHAR(MAX))
RETURNS VARCHAR(MAX) AS
BEGIN
	IF UPPER(ISNULL(@OldValue, '')) <> UPPER(ISNULL(@NewValue, ''))
		RETURN Tools.CamelCase(@NewValue);
	RETURN @OldValue;
END;
GO