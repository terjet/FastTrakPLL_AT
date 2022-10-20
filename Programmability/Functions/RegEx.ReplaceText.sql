SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [RegEx].[ReplaceText] (@Input [nvarchar](max),
@Pattern [nvarchar](max),
@Replacement [nvarchar](max))
RETURNS [nvarchar](max)
AS
EXTERNAL NAME [MsSqlRegEx].[SqlRegEx].[ReplaceText]
GO