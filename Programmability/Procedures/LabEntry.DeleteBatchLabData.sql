﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [LabEntry].[DeleteBatchLabData](@BatchId INT) AS
BEGIN
    SET NOCOUNT ON;
	DELETE FROM dbo.LabData
	WHERE (BatchId = @BatchId) AND (SignedBy IS NULL);
    SELECT @@ROWCOUNT AS RowsDeleted;
END;
GO