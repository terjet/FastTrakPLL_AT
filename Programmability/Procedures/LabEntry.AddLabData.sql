SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [LabEntry].[AddLabData] (@PersonId INT, @LabDate DATETIME, @LabName VARCHAR(40), @NumResult FLOAT,
    @DevResult INT = NULL, @TxtResult VARCHAR(MAX) = NULL, @Comment VARCHAR(MAX) = NULL,
    @ArithmeticComp CHAR(2) = NULL, @UnitStr VARCHAR(24) = NULL, @BatchId INTEGER = NULL, @RefInterval VARCHAR(MAX) = NULL) AS
BEGIN
   EXEC dbo.AddOrUpdateLabResult @PersonId, @LabDate, NULL, @LabName, @NumResult, @DevResult, @TxtResult, @Comment, @ArithmeticComp, @UnitStr, @BatchId, @RefInterval;
   -- Retrieve some information about the labdata that was added/updated.
   SELECT ld.ResultId, lc.LabCodeId, ld.NumResult, ld.TxtResult FROM dbo.LabCode lc
   JOIN dbo.LabData ld ON ld.LabCodeId = lc.LabCodeId AND ld.PersonId = @PersonId AND ld.LabDate = @LabDate 
   WHERE lc.LabName = @LabName AND ISNULL(lc.UnitStr,'') = ISNULL(@UnitStr,'');
END;
GO