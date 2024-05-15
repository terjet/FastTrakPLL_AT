SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[UpdateDrugTreatment]( @PersonId INT, @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    MERGE
    INTO dbo.DrugTreatment Trg 
    USING ( SELECT * FROM eResept.DrugTreatmentFromXml( @XmlDoc ) ) Src
    ON ( Trg.PersonId = @PersonId AND Trg.FmLibId = Src.LibId )
    WHEN NOT MATCHED BY TARGET

      THEN INSERT ( 
        FmLibId, PersonId, ATC, DrugName, DrugForm, 
        StartAt, StartReason, RegistrertAv,
        Strength, StrengthUnit, RxText, TreatType, PackType, 
        DobbeltForskrivningsvarsel, SignedBy, StopAt,
        DoseCode, Forskrivningskladd, Seponeringskladd, SeponertAv, StopReason
      )
      VALUES ( 
        Src.LibId, @PersonId, Src.ATC, Src.DrugName, Src.DrugForm, 
        Src.StartAt, Src.StartReason, Src.RegistrertAv,
        Src.Strength, Src.StrengthUnit, Src.RxText, Src.TreatType, src.PackType,
        Src.DobbeltForskrivningsvarsel, NULL, Src.StopAt, 
        Src.DoseCode, Src.Forskrivningskladd, Src.Seponeringskladd, Src. SeponertAv, Src.StopReason
      )

    WHEN MATCHED
      
      THEN UPDATE SET 
        Trg.ATC = Src.ATC,
        Trg.Varenr = Src.Varenr,
        Trg.DrugName = Src.DrugName,
        Trg.DrugForm = Src.DrugForm,
        Trg.StartAt = Src.StartAt,
        Trg.Strength = Src.Strength,
        Trg.StrengthUnit = Src.StrengthUnit,
        Trg.RxText = Src.RxText,
        Trg.TreatType = Src.TreatType,
        Trg.StopBy = USER_ID(),
        Trg.StopAt = Src.StopAt,
        Trg.StopReason = Src.StopReason,
        Trg.DobbeltForskrivningsvarsel = Src.DobbeltForskrivningsvarsel,
        Trg.StartReason = SUBSTRING(Src.StartReason,1,64),
        Trg.DoseCode = SUBSTRING(Src.DoseCode,1,32),
        Trg.Forskrivningskladd = Src.Forskrivningskladd,
        Trg.Seponeringskladd = Src.Seponeringskladd,
        Trg.SeponertAv = Src.SeponertAv,
        Trg.Seponeringsgrunn = Src.StopReason,
        Trg.RegistrertAv = Src.RegistrertAv
    WHEN NOT MATCHED BY SOURCE
      AND ( ( Trg.StopAt IS NULL OR Trg.StopAt > GETDATE() ) OR ( Trg.Seponeringskladd = 1 ) )
      AND ( Trg.PersonId = @PersonId )
      THEN UPDATE
        SET Trg.StopAt = GETDATE(),
        Trg.StopBy = DATABASE_PRINCIPAL_ID(),
        Trg.InteraksjonsKommentar = NULL,
        Trg.DobbeltForskrivningsvarsel = NULL,
        Trg.Seponeringskladd = 0,
        Trg.StopReason = 'Seponert i FM';

    UPDATE dbo.Person SET FMLastUpdate = GETDATE() WHERE PersonId = @PersonId;

  END TRY
  BEGIN CATCH

    DECLARE @ErrorMessage VARCHAR(MAX), @ErrorSeverity INT, @ErrorState INT;
    SELECT @ErrorMessage = CONCAT( ERROR_MESSAGE(), ' Line ', ERROR_LINE()), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

  END CATCH;

END
GO