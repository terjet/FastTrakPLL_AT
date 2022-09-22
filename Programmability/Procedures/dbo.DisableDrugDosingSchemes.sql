SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DisableDrugDosingSchemes]( @TreatId INT,@ChangedAt DateTime = NULL ) AS
  SET NOCOUNT ON;
  IF @ChangedAt IS NULL SET @ChangedAt = GetDate();
  UPDATE dbo.DrugDosing SET ValidUntil=@ChangedAt WHERE TreatId=@TreatId
    AND ( ValidUntil IS NULL OR ValidUntil > @ChangedAt );
  UPDATE dbo.DrugTreatment SET DoseId=NULL WHERE TreatId=@TreatId;
GO