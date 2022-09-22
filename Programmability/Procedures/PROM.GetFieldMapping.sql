SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[GetFieldMapping]( @FormOrderId VARCHAR(36) ) AS
BEGIN
	-- Map field names from Hemit PROMS form to FastTrak items in MetaItem, based on a form order in PROM.FormOrder table.
	SELECT fld.FieldName, fld.ItemId, mi.ItemType
	FROM dbo.MetaItem mi
	JOIN PROM.FieldMapping fld ON fld.ItemId = mi.ItemId
	JOIN PROM.FormMapping fm ON fm.PromId = fld.PromId
	JOIN PROM.FormOrder fo ON fo.PromUid = fm.PromUid
	WHERE fo.FormOrderId = @FormOrderId;
END
GO