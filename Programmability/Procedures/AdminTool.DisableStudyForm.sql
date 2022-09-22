SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[DisableStudyForm] ( @StudyId INT, @FormId INT, @Enable BIT = 0 ) AS
BEGIN
  DECLARE @DisabledAt DATETIME;
  DECLARE @DisabledBy INT;
  IF ISNULL(@Enable,0 ) = 0
  BEGIN
    SET @DisabledAt = GETDATE();
    SET @DisabledBy = USER_ID();
  END;
  UPDATE dbo.MetaStudyForm SET DisabledAt = @DisabledAt, DisabledBy = @DisabledBy
  WHERE StudyId = @StudyId AND FormId = @FormId;
END;
GO