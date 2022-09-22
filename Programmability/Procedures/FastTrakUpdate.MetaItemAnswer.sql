SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FastTrakUpdate].[MetaItemAnswer]( @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  UPDATE dbo.MetaItemAnswer SET LastUpdate = '1980-01-01';

  SELECT 
    x.r.value('@AnswerId', 'INT') AS AnswerId,
    x.r.value('@ItemId', 'INT') AS ItemId,
    x.r.value('@OrderNumber', 'INT') AS OrderNumber,
    x.r.value('@Score', 'FLOAT') AS Score,
    x.r.value('@OptionText', 'VARCHAR(max)') AS OptionText,
    x.r.value('@VerboseText', 'VARCHAR(max)') AS VerboseText,
    x.r.value('@HelpText', 'VARCHAR(max)') AS HelpText,
    x.r.value('@ShortCode', 'VARCHAR(5)') AS ShortCode,
    x.r.value('@ICD10', 'VARCHAR(16)') AS ICD10,
    x.r.value('@HtmlColor', 'VARCHAR(16)') AS HtmlColor,
    x.r.value('@IsDefaultAnswer', 'BIT') AS IsDefaultAnswer,
    x.r.value('@SCTID', 'BIGINT') AS SCTID,
    x.r.value('@LastUpdate', 'DATETIME') AS LastUpdate INTO #temp
  FROM @XmlDoc.nodes('/MetaItemAnswer/Row') AS x (r);

  -- Merge temporary table into dbo.MetaItemAnswer on AnswerId as key.

  MERGE INTO dbo.MetaItemAnswer mia USING ( SELECT * FROM #temp ) xd ON (mia.AnswerId = xd.AnswerId)
  WHEN MATCHED
    THEN UPDATE 
    SET mia.ItemId = xd.ItemId,
        mia.OrderNumber = xd.OrderNumber,
        mia.Score = xd.Score,
        mia.OptionText = xd.OptionText,
        mia.VerboseText = xd.VerboseText,
        mia.HelpText = xd.HelpText,
        mia.ShortCode = xd.ShortCode,
        mia.ICD10 = xd.ICD10,
        mia.HtmlColor = xd.HtmlColor,
        mia.IsDefaultAnswer = xd.IsDefaultAnswer,
        mia.SCTID = xd.SCTID,
        mia.LastUpdate = xd.LastUpdate
  WHEN NOT MATCHED
    THEN INSERT ( AnswerId, ItemId, OrderNumber, Score, OptionText, VerboseText, HelpText, ShortCode, ICD10, HtmlColor, IsDefaultAnswer, SCTID, LastUpdate )
      VALUES ( xd.AnswerId, xd.ItemId, xd.OrderNumber, xd.Score, xd.OptionText, xd.VerboseText, xd.HelpText, xd.ShortCode, xd.ICD10, xd.HtmlColor, xd.IsDefaultAnswer, xd.SCTID, xd.LastUpdate);
 
 DELETE FROM  dbo.MetaItemAnswer WHERE LastUpdate = '1980-01-01';

END
GO