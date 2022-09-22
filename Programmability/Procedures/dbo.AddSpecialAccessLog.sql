SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddSpecialAccessLog] (@PersonId INT, @Justification VARCHAR(MAX)) AS
BEGIN
  -- Find max length of the column
  DECLARE @MaxLen INT;
  SELECT @MaxLen = c.CHARACTER_MAXIMUM_LENGTH
  FROM INFORMATION_SCHEMA.COLUMNS c
  WHERE c.table_name = 'CaseLog'
  AND c.column_name = 'LogText'

  -- If length is greater than max-length raise an error
  IF DATALENGTH(@Justification) > @MaxLen
  BEGIN
    DECLARE @ErrMsg VARCHAR(MAX);
    SET @ErrMsg = 'Kommentaren kan maksimalt inneholde ' + CAST(@MaxLen - CHARINDEX(':', @Justification, 1) AS VARCHAR) + ' tegn!';
    RAISERROR (@ErrMsg, 16, 1);
    RETURN -1;
  END;
    
  INSERT INTO dbo.CaseLog (PersonId, LogType, LogText)
  VALUES (@PersonId, 'TILGANG', @Justification);
END
GO