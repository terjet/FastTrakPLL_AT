SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRxPrintQueue]( @PersonId INT )
AS 
BEGIN
  SELECT dt.*,rx.*,mrc.* 
  FROM DrugTreatment dt JOIN DrugPrescription rx ON rx.TreatId=dt.TreatId       
  LEFT OUTER JOIN MetaReimbursementCode mrc ON mrc.CodeId=rx.CodeId
  WHERE ( dt.PersonId=@PersonId ) AND ( rx.DeletedBy IS NULL );
END
GO

GRANT EXECUTE ON [dbo].[GetRxPrintQueue] TO [FastTrak]
GO