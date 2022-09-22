SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteDrugReaction]( @DRId INT ) AS
BEGIN
  SET NOCOUNT ON;
  IF EXISTS ( SELECT 1 FROM dbo.DrugReaction WHERE DRId = @DRId AND CaveId IS NOT NULL )
    RAISERROR( 'Du kan ikke slette en legemiddelreaksjon som er registrert i FM.\nAlle endringer på denne legemiddelreaksjonen må gjøres i FM.', 16, 1 )
  ELSE
    UPDATE dbo.DrugReaction SET DeletedAt = GETDATE(), DeletedBy = USER_ID(), Avkreftet = 1 
    WHERE DRId = @DRId AND DeletedBy IS NULL;
END
GO

GRANT EXECUTE ON [dbo].[DeleteDrugReaction] TO [FastTrak]
GO