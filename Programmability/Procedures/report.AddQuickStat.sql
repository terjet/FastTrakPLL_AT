SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[AddQuickStat](@StudyId INT, @ProcId INT, @Title VARCHAR(80), @DataElements VARCHAR(MAX), @Comment VARCHAR(MAX))
AS
BEGIN
  DECLARE @RowId INT;
  SELECT @RowId = RowId
  FROM Report.QuickStat
  WHERE StudyId = @StudyId
    AND Title = @Title;
  IF @RowId IS NULL
  BEGIN
    INSERT INTO Report.QuickStat(StudyId, ProcId, Title, DataElements, Comment) VALUES (@StudyId, @ProcId, @Title, @DataElements, @Comment)
    SET @RowId = scope_identity();
  END
  ELSE
    UPDATE Report.QuickStat SET ProcId = @ProcId, DataElements = @DataElements, Comment = @Comment
    WHERE RowId = @RowId;
  SELECT @RowId AS RowId;
END
GO

GRANT EXECUTE ON [report].[AddQuickStat] TO [superuser]
GO