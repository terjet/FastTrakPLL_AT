SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [RegEx].[MatchPos] (@Input [nvarchar](max),
@Pattern [nvarchar](max))
RETURNS [int]
AS
EXTERNAL NAME [MsSqlRegEx].[SqlRegEx].[MatchPos]
GO