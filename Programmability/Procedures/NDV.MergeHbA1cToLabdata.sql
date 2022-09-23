SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[MergeHbA1cToLabdata] AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @MergedName VARCHAR(32);
  DECLARE @LabCodeId INT;

  -- Make sure that we have a LabCode for the form data.
  SET @MergedName = 'B-HbA1c (skjema)';
  SELECT @LabCodeId = LabCodeId FROM dbo.LabCode WHERE LabName = @MergedName AND UnitStr = 'mmol/mol';
  IF @LabCodeId IS NULL
  BEGIN
    INSERT INTO dbo.LabCode ( LabName, UnitStr, VarName, LabClassId ) VALUES( @MergedName, 'mmol/mol', 'HBA1C_MMOL', 1058);
    SET @LabCodeId = SCOPE_IDENTITY();
  END
  ELSE  
    UPDATE dbo.LabCode SET LabClassId = 1058 WHERE LabCodeId = @LabCodeId;

  -- Merge new data from forms into labdata
  MERGE dbo.LabData AS trg 
  USING
  ( 
    SELECT ce.PersonId, ce.EventTime, cdp.Quantity, 
      ROW_NUMBER() OVER ( PARTITION BY ce.PersonId, ce.EventNum ORDER BY cdp.RowId DESC ) AS ReverseOrder
    FROM dbo.ClinDataPoint cdp
    JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
    WHERE cdp.ItemId = 3018 AND Quantity > 0
  ) src
  ON trg.PersonId = src.PersonId AND trg.LabDate = src.EventTime AND trg.LabCodeId = @LabCodeId AND src.ReverseOrder = 1
  
  WHEN NOT MATCHED AND ( src.ReverseOrder = 1 ) THEN
    INSERT ( PersonId, LabDate, LabCodeId, NumResult, UnitStr )
    VALUES ( src.PersonId, src.EventTime, @LabCodeId, src.Quantity, 'mmol/mol' )
  WHEN MATCHED THEN
    UPDATE SET NumResult = src.Quantity;
    
END
GO

GRANT EXECUTE ON [NDV].[MergeHbA1cToLabdata] TO [FastTrak]
GO