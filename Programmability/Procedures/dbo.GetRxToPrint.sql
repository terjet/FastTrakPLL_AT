SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRxToPrint]( @PersonId INT, @RxType INT )
AS 
BEGIN
  SELECT dt.ATC,dt.DrugName,dt.DrugForm,dt.Strength,dt.StrengthUnit,dt.StartReason,rx.*,mrc.CodeText,mrt.RefillText 
  FROM DrugTreatment dt JOIN DrugPrescription rx ON rx.TreatId=dt.TreatId       
  LEFT OUTER JOIN MetaReimbursementCode mrc ON mrc.CodeId=rx.CodeId      
  LEFT OUTER JOIN MetaRefillText mrt ON mrt.Refills = rx.Refills
  WHERE dt.PersonId=@PersonId AND rx.RxPrint=1 AND rx.RxType=@RxType AND rx.DeletedBy IS NULL
END
GO