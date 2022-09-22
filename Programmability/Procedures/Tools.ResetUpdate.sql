SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[ResetUpdate] AS
BEGIN
  UPDATE MetaFormItem SET LastUpdate = '2000-01-01'
  UPDATE MetaForm SET LastUpdate = '2000-01-01'
  UPDATE MetaItemAnswer SET LastUpdate = '2000-01-01'
  UPDATE MetaItem SET LastUpdate = '2000-01-01'
END
GO