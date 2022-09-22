SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[AddVarCaption](@VarSpec VARCHAR(60), @Caption VARCHAR(8))
AS
BEGIN
  DECLARE @CaptionId INT;
  SELECT @CaptionId = CaptionId
  FROM Report.ColumnCaption
  WHERE VarSpec = @VarSpec;
  IF @CaptionId IS NULL
  BEGIN
    SELECT @CaptionId = isnull(max(CaptionId), 1)
    FROM Report.ColumnCaption;
    SET @CaptionId = @CaptionId + 1;
    INSERT INTO Report.ColumnCaption(CaptionId, VarSpec, Caption) VALUES (@CaptionId, @VarSpec, @Caption);
  END
  ELSE
    UPDATE Report.ColumnCaption SET Caption = @Caption
    WHERE CaptionId = @CaptionId;
END
GO

GRANT EXECUTE ON [report].[AddVarCaption] TO [FastTrak]
GO