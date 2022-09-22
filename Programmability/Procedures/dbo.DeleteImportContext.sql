SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteImportContext]( @ContextId INT ) AS
BEGIN
  DELETE FROM ImportBatch WHERE ContextId=@ContextId;
END;
GO

GRANT EXECUTE ON [dbo].[DeleteImportContext] TO [FastTrak]
GO