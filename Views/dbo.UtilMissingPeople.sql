SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[UtilMissingPeople]
AS
  SELECT DISTINCT substring(ErrorMessages,45,300) as ErrMsg from ImportBatch
  WHERE ErrorCount > 0 AND charindex( 'Fant ingen', ErrorMessages) > 1
GO