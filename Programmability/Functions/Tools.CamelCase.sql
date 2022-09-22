SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [Tools].[CamelCase] (@Str VARCHAR(MAX))
RETURNS VARCHAR(MAX) AS
BEGIN
	DECLARE @Result VARCHAR(MAX);
	SET @Str = LOWER(@Str) + ' '
	SET @Result = ''

	WHILE PATINDEX('% %', @Str) > 0
	BEGIN
		SET @Result = @Result + UPPER(LEFT(@Str, 1)) + SUBSTRING(@Str, 2, CHARINDEX(' ', @Str) - 1);
		SET @Str = SUBSTRING(@Str, CHARINDEX(' ', @Str) + 1, LEN(@Str));
	END
	SET @Result = LEFT(@Result, LEN(@Result));
	RETURN @Result;
END;
GO