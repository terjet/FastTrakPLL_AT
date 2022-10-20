SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[UpdateDrugTreatment]( @PersonId INT, @XmlDoc XML ) AS
BEGIN

  SET NOCOUNT ON;

  BEGIN TRY

    SELECT *,  
      TRY_CONVERT( FLOAT, SUBSTRING( StrengthStr, 1, PatIndexStrength - 1 ) ) AS Strength,
      SUBSTRING( StrengthStr, PatIndexStrength, 32 ) AS StrengthUnit 
      INTO #DrugTreatment
    FROM
    (
    SELECT 
      rdl.value( '../LibId[1]', 'uniqueidentifier' ) AS LibId,
      rdl.value( '../Varenavn[1]', 'VARCHAR(256)' ) AS DrugName,
      rdl.value( '../Legemiddelform[1]', 'VARCHAR(64)' ) AS DrugForm,
      rdl.value( '../Styrke[1]', 'VARCHAR(24)' ) AS StrengthStr,
      PATINDEX('%[^0-9,.]%', rdl.value('../Styrke[1]', 'VARCHAR(24)' ) ) AS PatIndexStrength,
      SUBSTRING( 'FKB', rdl.value( 'Forskrivning[1]/Bruk[1]/@V', 'INT' ), 1 ) AS TreatType,
      rdl.value( '../Administrering[1]/Type[1]', 'CHAR(1)' ) AS PackType,
      rdl.value( '../InstitueringsDato[1]', 'DATE' ) AS StartAt,
      rdl.value( '../SeponeringsInfomasjon[1]/Seponeringsdato[1]', 'DATE' ) AS LastUseDate,
      rdl.value( '../SeponeringsInfomasjon[1]/Seponeringstidspunkt[1]', 'DATETIME' ) AS Seponeringstidspunkt,
      rdl.value( '../SeponeringsInfomasjon[1]/Seponeringsgrunn[1]', 'VARCHAR(64)' ) AS Seponeringsgrunn,
      rdl.value( '../SeponeringsInfomasjon[1]/SeponertAv[1]', 'VARCHAR(60)' ) AS SeponertAv,
      ISNULL( rdl.value( '../Kladd[1]', 'BIT' ), 0 ) AS Forskrivningskladd,
      ISNULL( rdl.value( '../Seponeringskladd[1]', 'BIT' ), 0 ) AS Seponeringskladd,
      rdl.value( '../RegistrertAv[1]', 'VARCHAR(60)' ) AS RegistrertAv,
      rdl.value( '../DobbeltForskrivningsvarsel[1]', 'VARCHAR(1024)' ) AS DobbeltForskrivningsvarsel,
      rdl.value( 'Forskrivning[1]/Bruksomrade[1]', 'VARCHAR(1024)' ) AS StartReason,
      rdl.value( 'Forskrivning[1]/DosVeiledEnkel[1]', 'VARCHAR(1024)' ) AS RxText,
      rdl.value( 'Forskrivning[1]/Kortdose[1]/@DN', 'VARCHAR(1024)' ) AS DoseCode,
      rdl.value( 'Forskrivning[1]/Legemiddelpakning[1]/Varenr[1]', 'INT' ) AS Varenr,
      rdl.value( 'Forskrivning[1]/Legemiddelpakning[1]/Atc[1]/@V', 'VARCHAR(7)' ) AS LegemiddelpakningATC,
      rdl.value( 'Forskrivning[1]/LegemiddelVirkestoff[1]/Atc[1]/@V', 'VARCHAR(7)' ) AS LegemiddelVirkestoffATC,
      rdl.value( '../VarselSlv[1]/Type[1]/@V', 'INT' ) AS VarselSlvTypeV,
      rdl.value( '../VarselSlv[1]/Type[1]/@DN', 'VARCHAR(1024)' ) AS VarselSlvTypeDN,
      rdl.value( '../VarselSlv[1]/Overskrift[1]', 'VARCHAR(1024)' ) AS VarselSlvOverskrift,
      rdl.value( '../VarselSlv[1]/Varseltekst[1]', 'VARCHAR(1024)' ) AS VarselSlvVarseltekst,
      CONVERT(VARCHAR(MAX), rdl.query('data(../CaveVarsel/CaveId)')) AS CaveIdList
    FROM  @XmlDoc.nodes( 'LesVarerIBrukSvar/Resept/ReseptDokLegemiddel' ) AS xd(rdl)
    ) a;

    MERGE
    INTO dbo.DrugTreatment Trg USING ( SELECT * FROM #DrugTreatment WHERE TreatType IS NOT NULL ) Src
    ON ( Trg.PersonId = @PersonId AND Trg.FmLibId = Src.LibId )
    WHEN NOT MATCHED BY TARGET
      THEN INSERT ( FmLibId, PersonId, ATC, DrugName, DrugForm, StartAt, StartReason, 
        Strength, StrengthUnit, RxText, TreatType, 
        DobbeltForskrivningsvarsel, SignedBy, CaveIdList, StopAt,
        DoseCode, Forskrivningskladd, Seponeringskladd, SeponertAv, Seponeringsgrunn, RegistrertAv,
        VarselSlvTypeV, VarselSlvTypeDN, VarselSlvOverskrift, VarselSlvTekst)
      VALUES ( Src.LibId, @PersonId, Src.LegemiddelPakningAtc, Src.DrugName, Src.DrugForm, Src.StartAt, Src.StartReason, 
          Src.Strength, Src.StrengthUnit, Src.RxText, Src.TreatType, 
          Src.DobbeltForskrivningsvarsel, NULL, NULLIF(Src.CaveIdList,''), Src.Seponeringstidspunkt, 
          Src.DoseCode, Src.Forskrivningskladd, Src.Seponeringskladd, 
          Src.SeponertAv, Src.Seponeringsgrunn, Src.RegistrertAv,
          Src.VarselSlvTypeV, Src.VarselSlvTypeDN, Src.VarselSlvOverskrift, Src.VarselSlvVarseltekst)

    WHEN MATCHED
      THEN UPDATE
        SET Trg.ATC = Src.LegemiddelPakningATC,
        Trg.DrugName = Src.DrugName,
        Trg.DrugForm = Src.DrugForm,
        Trg.StartAt = Src.StartAt,
        Trg.Strength = Src.Strength,
        Trg.StrengthUnit = Src.StrengthUnit,
        Trg.RxText = Src.RxText,
        Trg.TreatType = Src.TreatType,
        Trg.StopBy = USER_ID(),
        Trg.StopAt = Src.Seponeringstidspunkt,
        Trg.StopReason = Src.Seponeringsgrunn,
        Trg.DobbeltForskrivningsvarsel = Src.DobbeltForskrivningsvarsel,
        Trg.CaveIdList = NULLIF(Src.CaveIdList,''),
        Trg.StartReason = SUBSTRING(Src.StartReason,1,64),
        Trg.DoseCode = SUBSTRING(Src.DoseCode,1,32),
        Trg.Forskrivningskladd = Src.Forskrivningskladd,
        Trg.Seponeringskladd = Src.Seponeringskladd,
        Trg.SeponertAv = Src.SeponertAv,
        Trg.Seponeringsgrunn = Src.Seponeringsgrunn,
        Trg.RegistrertAv = Src.RegistrertAv,
        Trg.VarselSlvTypeV = Src.VarselSlvTypeV,
        Trg.VarselSlvTypeDN = Src.VarselSlvTypeDN,
        Trg.VarselSlvOverskrift = Src.VarselSlvOverskrift,
        Trg.VarselSlvTekst = Src.VarselSlvVarseltekst
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