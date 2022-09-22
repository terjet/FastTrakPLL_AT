SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[CopyFieldMapping]( @FromPromId INT, @ToPromId INT ) AS
BEGIN
  INSERT INTO PROM.FieldMapping( PromId,FieldName,ItemId)
  SELECT @ToPromId, FieldName,ItemId FROM PROM.FieldMapping WHERE PromId=@FromPromId 
END
GO