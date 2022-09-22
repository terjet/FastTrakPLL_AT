SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddLabName]( @LabName VARCHAR(40), @UnitStr VARCHAR(24) = NULL ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @LabCodeId INT;
  SET @UnitStr = ISNULL( @UnitStr, '' );
  SELECT @LabCodeId = LabCodeId FROM dbo.LabCode WHERE LabName = @LabName AND UnitStr=@UnitStr;
  IF @LabCodeId IS NULL
  BEGIN
    INSERT INTO dbo.LabCode( LabName, UnitStr ) VALUES ( @LabName, @UnitStr );
    SET @LabCodeId = SCOPE_IDENTITY();
  END;
  SELECT lc.LabCodeId, lc.LabName, lc.UnitStr, lcl.VarName, lcl.Loinc AS LoincCode, lc.SynonymId, lc.CreatedAt, lc.CreatedBy
  FROM dbo.LabCode lc 
  LEFT OUTER JOIN dbo.LabClass lcl ON lcl.LabClassId=lc.LabClassId 
  WHERE lc.LabCodeId = @LabCodeId;
END
GO