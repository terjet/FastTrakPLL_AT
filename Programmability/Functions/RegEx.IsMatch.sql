SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [RegEx].[IsMatch] (@Input [nvarchar](max),
@Pattern [nvarchar](max))
RETURNS [int]
AS
EXTERNAL NAME [MsSqlRegEx].[SqlRegEx].[IsMatch]
GO