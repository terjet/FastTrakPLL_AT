SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDrugPrescriptionPrintStatus]( @PrescId INT, @RxPrint INT ) AS
BEGIN
  DECLARE @OldStatus INT;
  SELECT @OldStatus = RxPrint FROM DrugPrescription WHERE PrescId=@PrescId;
  IF @OldStatus > 1
  BEGIN 
    RAISERROR('Resepten kunne ikke endre status', 16, 1);
    RETURN -1;
  END
  ELSE
  BEGIN  
    UPDATE DrugPrescription SET RxPrint=@RxPrint WHERE PrescId=@PrescId;
    IF @RxPrint = 2 UPDATE DrugPrescription SET PrintedAt=getdate(),PrintedBy=USER_ID() WHERE PrescId=@PrescId;
  END; 
END
GO

GRANT EXECUTE ON [dbo].[UpdateDrugPrescriptionPrintStatus] TO [PrintPrescription]
GO

DENY EXECUTE ON [dbo].[UpdateDrugPrescriptionPrintStatus] TO [ReadOnly]
GO