SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLabNames] AS
BEGIN
  SELECT LabCodeId, LabName, UnitStr FROM dbo.LabCode;
END
GO

GRANT EXECUTE ON [dbo].[GetLabNames] TO [FastTrak]
GO