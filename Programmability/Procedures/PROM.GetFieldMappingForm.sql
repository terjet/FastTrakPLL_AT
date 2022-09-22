SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[GetFieldMappingForm]( @PromUid VARCHAR(36) ) AS
BEGIN
	-- Map field names from Hemit PROMS form to FastTrak items in MetaItem, based on a Hemit form.
	SELECT fld.FieldName, fld.ItemId, mi.ItemType
	FROM dbo.MetaItem mi
	JOIN PROM.FieldMapping fld ON fld.ItemId = mi.ItemId
	JOIN PROM.FormMapping fm ON fm.PromId = fld.PromId
	WHERE fm.PromUid = @PromUid;
END
GO