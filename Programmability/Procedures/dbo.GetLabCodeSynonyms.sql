SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLabCodeSynonyms]( @LabCodeId INT ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StdId INT;
  SELECT @StdId = LabCodeId FROM dbo.LabCode WHERE LabCodeId=@LabCodeId;
  SELECT LabCodeId, LabName, UnitStr FROM dbo.LabCode WHERE SynonymId = @StdId;
END;
GO