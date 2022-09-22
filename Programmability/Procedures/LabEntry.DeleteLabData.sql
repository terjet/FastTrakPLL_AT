SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [LabEntry].[DeleteLabData] (@ResultId INT, @BatchId INT) AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.LabData
    WHERE (ResultId = @ResultId)
        AND (BatchId = @BatchId)
        AND (SignedBy IS NULL);
    SELECT @@ROWCOUNT AS RowsDeleted;
END;
GO