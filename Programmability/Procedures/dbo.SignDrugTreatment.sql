SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SignDrugTreatment]( @TreatId INT ) AS
BEGIN
  IF dbo.CanSignDrugTreatment( USER_ID() ) = 1  
    UPDATE dbo.DrugTreatment SET SignedBy=USER_ID(),SignedAt=GETDATE() WHERE TreatId=@TreatId AND SignedBy IS NULL
  ELSE
    RAISERROR( 'Du har ikke anledning til å signere medikamenter!', 16, 1 );
END
GO