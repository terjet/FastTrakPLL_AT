SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugPermission]
AS
BEGIN
  DECLARE @CanModifyDrugTreatment BIT;
  DECLARE @ErrMsg VARCHAR(512); 
  EXEC dbo.CanModifyDrugTreatment  null, @CanModifyDrugTreatment OUTPUT, @ErrMsg OUTPUT 
  SELECT @CanModifyDrugTreatment as 'CanModify', @ErrMsg as 'ErrorMessage'
END
GO