SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateBatchErrors]( @BatchId INT, @ErrorCount INT, @ErrorMessages text )
AS
BEGIN
  UPDATE ImportBatch SET ErrorCount=@ErrorCount,ErrorMessages=@ErrorMessages,ClosedAt=getdate()
  WHERE Batchid=@BatchId
END
GO