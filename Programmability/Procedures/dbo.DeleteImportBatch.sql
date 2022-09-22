SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteImportBatch]( @BatchId INT ) AS
BEGIN
  /* Foreign keys will take care of the rest */
  DELETE FROM ImportBatch WHERE BatchId=@BatchId;
END;
GO