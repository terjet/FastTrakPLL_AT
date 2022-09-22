SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMetaPackTypes] AS
BEGIN
  SELECT PackType,PackDesc FROM MetaPackType WHERE Active=1 ORDER BY SortOrder
END
GO

GRANT EXECUTE ON [dbo].[GetMetaPackTypes] TO [FastTrak]
GO