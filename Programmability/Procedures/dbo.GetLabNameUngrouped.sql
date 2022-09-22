SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLabNameUngrouped] AS
BEGIN
  SELECT LabCodeId, LabName, UnitStr 
  FROM dbo.LabCode
  WHERE ( SELECT COUNT(*) FROM dbo.LabCodeGroup WHERE LabCodeId = LabCode.LabCodeId ) = 0;
END
GO

GRANT EXECUTE ON [dbo].[GetLabNameUngrouped] TO [FastTrak]
GO