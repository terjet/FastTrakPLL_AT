SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteDrugPrescription]( @PrescId INT )
AS
BEGIN
  UPDATE DrugPrescription SET DeletedAt=getdate(),DeletedBy=USER_ID() WHERE PrescId=@PrescId AND RxPrint in ( 0,1 ) AND DeletedBy IS NULL;
  IF @@ROWCOUNT = 0 RAISERROR( 'Denne resepten kunne ikke slettes.\nDen er allerede slettet eller utskrevet.', 16,1 ); 
END
GO

GRANT EXECUTE ON [dbo].[DeleteDrugPrescription] TO [DrugEditor]
GO