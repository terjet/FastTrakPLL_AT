SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [RegEx].[MatchText] (@Input [nvarchar](max),
@Pattern [nvarchar](max))
RETURNS [nvarchar](max)
AS
EXTERNAL NAME [MsSqlRegEx].[SqlRegEx].[MatchText]
GO