SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[OngoingTreatment] (TreatId, PersonId, ATC, ATCVersion, DrugName, DrugForm, TreatType, PackType, TreatPackType, Strength, StrengthUnit, Dose24hCount, Dose24hDD, StartAt, StartFuzzy, StartReason, RxText, StopAt, StopFuzzy, StopReason, DoseCode, PauseStatus, CreatedAt, DoseId, StartedBy, CreatedBy, StopBy ) 
AS
  SELECT TreatId, PersonId, ATC, ATCVersion, DrugName, DrugForm, TreatType, PackType, TreatPackType, Strength, StrengthUnit, Dose24hCount, Dose24hDD, StartAt, StartFuzzy, StartReason, RxText, StopAt, StopFuzzy, StopReason, DoseCode, PauseStatus, CreatedAt, DoseId, StartedBy, CreatedBy, StopBy 
  FROM DrugTreatment WHERE (StopAt IS NULL OR StopAt > getdate())
GO