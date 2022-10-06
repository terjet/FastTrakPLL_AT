SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[UpdateVIB] (@Personid INT, @XmlString NVARCHAR(MAX) ) AS
BEGIN
  BEGIN TRY

  DECLARE @Xml NVARCHAR(MAX) = @XmlString;
  SELECT @Xml = REPLACE(@Xml, 'xmlns="http://www.kith.no/xmlstds/eresept/forskrivning/2013-10-08"', '')
  SELECT @Xml = REPLACE(@Xml, 'xmlns="http://www.kith.no/xmlstds/eresept/m1/2013-10-08"', '')
  --SELECT @Xml = REPLACE(@Xml, 'xmlns=""http://www.kith.no/xmlstds/eresept/m1/2013-10-08""', '')

  DECLARE @TraceMethod VARCHAR(50) = 'eResept.UpdateVIB';
  DECLARE @TraceMessage VARCHAR(MAX);

  SELECT @TraceMessage = 'Enter eResept.UpdateVIB: PersonId=' + CAST(@PersonId AS VARCHAR)

  EXEC Tools.AddTraceMessage @TraceMethod, 0, @TraceMessage;
  EXEC Tools.AddTraceMessage @TraceMethod, 0, @Xml;

  DECLARE @DrugTreatmentXml TABLE (
    XML XML NOT NULL
  );

  INSERT INTO @DrugTreatmentXml
    VALUES (CONVERT(XML, @Xml));

  DECLARE @DrugTreatment TABLE (
    LibId VARCHAR(MAX) NOT NULL,
    LegemiddelpakningATC VARCHAR(7) NULL,
    LegemiddelVirkestoffATC VARCHAR(7) NULL,
    ATC VARCHAR(7) NULL,
    DrugName VARCHAR(1024) NULL,
    DrugForm VARCHAR(64) NULL,
    StrengthStr VARCHAR(MAX) NULL,
    Varenr INTEGER NULL,
    PatindexStrength INTEGER NULL,
    Strength DECIMAL(12, 4) NULL,
    StrengthUnit VARCHAR(24) NULL,
    StartAt DATETIME NULL,
    StartFuzzy INTEGER NULL,
    StartReason VARCHAR(MAX) NULL,
    DoseCode VARCHAR(MAX) NULL,
    RxText VARCHAR(MAX) NULL,
    TreatType VARCHAR(MAX) NULL,
    BatchId INTEGER NULL,
    PackType VARCHAR(1) NULL,
    Seponeringstidspunkt DATETIME2 NULL,
    Seponeringsdato DATETIME2 NULL,
    Seponeringsgrunn VARCHAR(MAX) NULL,
    Seponeringskladd BIT NULL,
    SeponertAv VARCHAR(MAX) NULL,
    SeponertAvUserId INT NULL,
    StopBy INT NULL,
    InteraksjonsNiva VARCHAR(MAX) NULL,
    InteraksjonsKommentar VARCHAR(MAX) NULL,
    DobbeltForskrivningsvarsel VARCHAR(MAX) NULL,
    Forskrivningskladd BIT NULL,
    RegistrertAv VARCHAR(MAX) NULL,
    RegistrertAvUserId INT NULL,
    CaveIdList VARCHAR(MAX),
    VarselSlvTypeV INT NULL,
    VarselSlvTypeDN VARCHAR(50) NULL,
    VarselSlvOverskrift VARCHAR(100) NULL,
    VarselSlvVarseltekst VARCHAR(MAX) NULL
  );

-- Extract from ReseptDokHandelsvare
  INSERT INTO @DrugTreatment (LibId, Drugname, Varenr, StartAt, StartReason, RxText, Seponeringstidspunkt, Seponeringsdato, Seponeringsgrunn,
  SeponertAv, Forskrivningskladd, RegistrertAv, Seponeringskladd, TreatType)
    SELECT
      -- LibId
      NULLIF(CAST(c.query('data(../LibId)') AS VARCHAR(64)), '') AS LibId,

      -- Varnavn
      NULLIF(CAST(c.query('data(ProdGruppe/@DN)') AS VARCHAR(1024)), '') AS DrugName,

      -- Varenr
      CONVERT(INTEGER, CAST(c.query('data(RefHjemmel/@V)') AS VARCHAR(10))) AS Varenr,

      -- StartAt
      CASE
        WHEN CAST(c.query('data(../InstitueringsDato)') AS VARCHAR(MAX)) = '' THEN NULL
        ELSE TRY_CONVERT(DATETIME2, CAST(c.query('data(../InstitueringsDato)') AS VARCHAR(MAX)))
      END AS StartAt,

      -- Bruksomrade
      CAST(c.query('data(Bruksveiledning)') AS VARCHAR(MAX)) AS StartReason,

      -- DosVeiledEnkel
      CAST(c.query('data(Merknad)') AS VARCHAR(MAX)) AS RxText,

      -- Seponeringstidspunkt
      CASE
        WHEN
          CAST(c.query('data(../SeponeringsInfomasjon/Seponeringstidspunkt)') AS VARCHAR(MAX)) = '' THEN NULL
        ELSE TRY_CONVERT(DATETIME2, CAST(c.query('data(../SeponeringsInfomasjon/Seponeringstidspunkt)') AS VARCHAR(MAX)))
      END AS Seponeringstidspunkt,

      -- Seponeringsdato
      CASE
        WHEN
          CAST(c.query('data(../SeponeringsInfomasjon/Seponeringsdato)') AS VARCHAR(MAX)) = '' THEN NULL
        ELSE TRY_CONVERT(DATETIME2, CAST(c.query('data(../SeponeringsInfomasjon/Seponeringsdato)') AS VARCHAR(MAX)))
      END AS Seponeringsdato,

      -- Seponeringsgrunn
      NULLIF(CAST(c.query('data(../SeponeringsInfomasjon/Seponeringsgrunn)') AS VARCHAR(MAX)), '') AS Seponeringsgrunn,

      -- SeponertAv
      NULLIF(CAST(c.query('data(../SeponeringsInfomasjon/SeponertAv)') AS VARCHAR(MAX)), '') AS SeponertAv,

      -- Kladd
      CONVERT(BIT, CAST(c.query('data(../Kladd)') AS NVARCHAR(MAX))) AS Forskrivingskladd,

      -- RegistrertAv
      NULLIF(CAST(c.query('data(../RegistrertAv )') AS VARCHAR(MAX)), '') AS RegistrertAv,

      -- SeponeringsInfomasjon/Kladd
      CONVERT(BIT, CAST(c.query('data(../SeponeringsInfomasjon/Kladd)') AS NVARCHAR(MAX))) AS Seponeringskladd,
      'N' AS TreatType
    FROM @DrugTreatmentXml dtx
    CROSS APPLY Xml.nodes('LesVarerIBrukSvar/Resept/ReseptDokHandelsvare') x (c);

    DELETE FROM @DrugTreatment  WHERE Varenr NOT BETWEEN 601 AND 604; -- Magic numbers

  -- Extract from ReseptDokLegemiddel
  INSERT INTO @DrugTreatment (InteraksjonsNiva, InteraksjonsKommentar, LibId, LegemiddelpakningATC, LegemiddelVirkestoffATC, Drugname,
  Drugform, StrengthStr, Varenr, StartAt, StartReason, DoseCode,
  RxText, TreatType, PatindexStrength, PackType, Seponeringstidspunkt, Seponeringsdato,
  Seponeringsgrunn, SeponertAv, DobbeltForskrivningsvarsel, Forskrivningskladd, RegistrertAv, CaveIdList,
  Seponeringskladd, VarselSlvTypeV, VarselSlvTypeDN, VarselSlvOverskrift, VarselSlvVarseltekst)
    SELECT
      -- InteraksjonsNiva
      CONVERT(INT, CAST(c.query('data(../InteraksjonsInformasjon/InteraksjonsNiva/@V)') AS VARCHAR(10))) AS InteraksjonsNiva,

      -- InteraksjonsKommentar
      NULLIF(CAST(c.query('data(../InteraksjonsInformasjon/Kommentar)') AS VARCHAR(MAX)), '') AS InteraksjonsKommentar,

      -- LibId
      NULLIF(CAST(c.query('data(../LibId)') AS VARCHAR(64)), '') AS LibId,

      -- ATC fra Legemiddelpakning
      NULLIF(CAST(c.query('data(Forskrivning/Legemiddelpakning/Atc/@V)') AS VARCHAR(7)), '') AS LegemiddelpakningATC,

      -- ATC fra LegemiddelVirkestoff
      NULLIF(CAST(c.query('data(Forskrivning/LegemiddelVirkestoff/Atc/@V)') AS VARCHAR(7)), '') AS LegemiddelVirkestoffATC,

      -- Varnavn
      NULLIF(CAST(c.query('data(../Varenavn)') AS VARCHAR(1024)), '') AS DrugName,

      -- Legemiddelform
      NULLIF(CAST(c.query('data(../Legemiddelform)') AS VARCHAR(MAX)), '') AS DrugForm,

      -- Styrke
      NULLIF(CAST(c.query('data(../Styrke)') AS VARCHAR(MAX)), '') AS StrengthStr,

      -- Varenr
      CONVERT(INTEGER, CAST(c.query('data(Forskrivning/Legemiddelpakning/Varenr)') AS VARCHAR(10))) AS Varenr,

      -- StartAt
      CASE
        WHEN CAST(c.query('data(../InstitueringsDato)') AS VARCHAR(MAX)) = '' THEN NULL
        ELSE TRY_CONVERT(DATETIME2, CAST(c.query('data(../InstitueringsDato)') AS VARCHAR(MAX)))
      END AS StartAt,

      -- Bruksomrade
      CAST(c.query('data(Forskrivning/Bruksomrade)') AS VARCHAR(MAX)) AS StartReason,

      -- Kortdose: Enten fra KortdoseDN, eller fra DosVeiledEnkel
      COALESCE(
      NULLIF(CAST(c.query('data(Forskrivning/Kortdose/@DN)') AS VARCHAR(MAX)), ''),
      NULLIF(CAST(c.query('data(Forskrivning/DosVeiledEnkel)') AS VARCHAR(MAX)), '')) AS DoseCode,

      -- DosVeiledEnkel
      CAST(c.query('data(Forskrivning/DosVeiledEnkel)') AS VARCHAR(MAX)) AS RxText,

      -- TreatType: Mappet
      CASE CAST(c.query('data(Forskrivning/Bruk/@V)') AS VARCHAR(MAX))
        WHEN '1' THEN 'F'
        WHEN '2' THEN 'K'
        WHEN '3' THEN 'B'
        ELSE NULL
      END AS TreatType,

      -- PatindexStrength: Extract where the first char which is not part of a number begins
      PATINDEX('%[^0-9,.]%', CAST(c.query('data(../Styrke)') AS VARCHAR(MAX))) AS PatindexStrength,

      -- PackType
      NULLIF(CAST(c.query('data(../Administrering/Type)') AS VARCHAR(1)), '') AS PackType,

      -- Seponeringstidspunkt
      CASE
        WHEN
          CAST(c.query('data(../SeponeringsInfomasjon/Seponeringstidspunkt)') AS VARCHAR(MAX)) = '' THEN NULL
        ELSE TRY_CONVERT(DATETIME2, CAST(c.query('data(../SeponeringsInfomasjon/Seponeringstidspunkt)') AS VARCHAR(MAX)))
      END AS Seponeringstidspunkt,

      -- Seponeringsdato
      CASE
        WHEN
          CAST(c.query('data(../SeponeringsInfomasjon/Seponeringsdato)') AS VARCHAR(MAX)) = '' THEN NULL
        ELSE TRY_CONVERT(DATETIME2, CAST(c.query('data(../SeponeringsInfomasjon/Seponeringsdato)') AS VARCHAR(MAX)))
      END AS Seponeringsdato,

      -- Seponeringsgrunn
      NULLIF(CAST(c.query('data(../SeponeringsInfomasjon/Seponeringsgrunn)') AS VARCHAR(MAX)), '') AS Seponeringsgrunn,

      -- SeponertAv
      NULLIF(CAST(c.query('data(../SeponeringsInfomasjon/SeponertAv)') AS VARCHAR(MAX)), '') AS SeponertAv,

      -- DobbeltForskrivningsvarsel
      NULLIF(CAST(c.query('data(../DobbeltForskrivningsvarsel)') AS VARCHAR(MAX)), '') AS DobbeltForskrivningsvarsel,

      -- Kladd
      CONVERT(BIT, CAST(c.query('data(../Kladd)') AS NVARCHAR(MAX))) AS Forskrivningskladd,

      -- RegistrertAv
      NULLIF(CAST(c.query('data(../RegistrertAv )') AS VARCHAR(MAX)), '') AS RegistrertAv,

      -- CaveId
      NULLIF(CAST(c.query('data(../CaveVarsel/CaveId)') AS VARCHAR(40)), '') AS CaveId,

      -- SeponeringsInfomasjon/Kladd
      CONVERT(BIT, CAST(c.query('data(../SeponeringsInfomasjon/Kladd)') AS NVARCHAR(MAX))) AS Seponeringskladd,

      CONVERT(BIT, CAST(c.query('data(../VarselSlv/Type/@V)') AS NVARCHAR(MAX))) AS VarselSlvTypeV,

      NULLIF(CAST(c.query('data(../VarselSlv/Type/@DN)') AS VARCHAR(MAX)), '') AS VarselSlvTypeDN,

      NULLIF(CAST(c.query('data(../VarselSlv/Overskrift)') AS VARCHAR(MAX)), '') AS VarselSlvOverskrift,

      NULLIF(CAST(c.query('data(../VarselSlv/Varseltekst)') AS VARCHAR(MAX)), '') AS VarselSlvVarseltekst
    FROM @DrugTreatmentXml dtx
    CROSS APPLY Xml.nodes('LesVarerIBrukSvar/Resept/ReseptDokLegemiddel') x (c);

  UPDATE @DrugTreatment
  SET DobbeltForskrivningsvarsel = NULL
  WHERE DobbeltForskrivningsvarsel = '';

  -- Extract Strength and StrengthUnit
  UPDATE @DrugTreatment
  SET Strength = CAST(REPLACE(SUBSTRING(StrengthStr, 0, PatindexStrength), ',', '.') AS DECIMAL(12, 4)),
  StrengthUnit = RIGHT(StrengthStr, LEN(StrengthStr) - PatindexStrength)
  WHERE PatindexStrength > 0
  AND LEN(RIGHT(StrengthStr, LEN(StrengthStr) - PatindexStrength)) < 24;

  -- Add StopBy
  MERGE
  INTO @DrugTreatment Trg USING (SELECT UserId, FMUserName
    FROM dbo.UserList) Src
  ON (Trg.SeponertAv = Src.FMUserName)
  WHEN MATCHED
    THEN UPDATE
      SET Trg.StopBy = Src.UserId;

  -- Add CreatedBy
  MERGE
  INTO @DrugTreatment Trg USING (SELECT UserId, FMUserName
    FROM dbo.UserList) Src
  ON (Trg.RegistrertAv = Src.FMUserName) 
  WHEN MATCHED
    THEN UPDATE
      SET Trg.RegistrertAvUserId = Src.UserId;

  -- Oppdater de som vi mangler bruker på. Da legger vi inn dummy-lege fra profil.

  UPDATE @DrugTreatment
  SET RegistrertAvUserId = USER_ID('Ordinertiprofil')
  WHERE RegistrertAv IS NULL;

  -- CreatedBy er den som oppretter raden. Dette er imidlertid ikke korrekt i FastTrak. Vi må hente brukeren fra XML-svaret
  -- Dersom vi ikke har  CreatedBy/SignedBy/StartedBy/StopBy må vi ha en dummy-bruker "Ordinert i Profil"

  -- Select ATC
  UPDATE @DrugTreatment
  SET ATC = COALESCE(NULLIF(LegemiddelpakningATC, ''), NULLIF(LegemiddelVirkestoffATC, ''));

  -- Handelsvarer skal være TreatType X
  -- Varenummer som begynner med 601-604
  -- FIB uinteressant
  -- Vaksiner uinteressant
  -- Sjekk med Magne om næringmidler kan legges inn i PIA - eller, det kommer ikke over allikevel.

  MERGE
  INTO dbo.DrugTreatment Trg USING (SELECT * FROM @DrugTreatment WHERE TreatType IS NOT NULL) Src
  ON (Trg.PersonId = @Personid
    AND Trg.FMLibId = Src.LibId)
  WHEN NOT MATCHED BY TARGET
    THEN INSERT (FMLibId, PersonId, ATC, DrugName, DrugForm, StartAt, StartReason, Strength,
      StrengthUnit, RxText, TreatType, InteraksjonsNiva, InteraksjonsKommentar,
      DobbeltForskrivningsvarsel, SignedBy, CaveIdList, StopAt,
      DoseCode, Forskrivningskladd, Seponeringskladd, SeponertAv, Seponeringsgrunn, RegistrertAv,
      VarselSlvTypeV, VarselSlvTypeDN, VarselSlvOverskrift, VarselSlvTekst)
        VALUES (Src.LibId, @PersonId, Src.ATC, Src.DrugName, Src.DrugForm, 
        Src.StartAt, SUBSTRING(Src.StartReason,1,64), Src.Strength,
        Src.StrengthUnit, Src.RxText, Src.TreatType, Src.InteraksjonsNiva, Src.InteraksjonsKommentar,
        Src.DobbeltForskrivningsvarsel, Src.RegistrertAvUserId, Src.CaveIdList, Src.Seponeringsdato, -- Skal src.CaveIdList være her?
        SUBSTRING(Src.DoseCode,1,32),
        ISNULL(Src.Forskrivningskladd,0), ISNULL(Src.Seponeringskladd,0), Src.SeponertAv, Src.Seponeringsgrunn, Src.RegistrertAv,
        Src.VarselSlvTypeV, Src.VarselSlvTypeDN, Src.VarselSlvOverskrift, Src.VarselSlvVarseltekst)

  WHEN MATCHED
    THEN UPDATE
      SET Trg.ATC = Src.ATC,
      Trg.DrugName = Src.DrugName,
      Trg.DrugForm = Src.DrugForm,
      Trg.StartAt = Src.StartAt,
      Trg.Strength = Src.Strength,
      Trg.StrengthUnit = Src.StrengthUnit,
      Trg.RxText = Src.RxText,
      Trg.TreatType = Src.TreatType,
      Trg.StopAt = Src.Seponeringsdato,
      Trg.StopReason = Src.Seponeringsgrunn,
      Trg.StopBy = Src.StopBy,
      Trg.InteraksjonsNiva = Src.InteraksjonsNiva, Trg.InteraksjonsKommentar = Src.InteraksjonsKommentar,
      Trg.DobbeltForskrivningsvarsel = Src.DobbeltForskrivningsvarsel, Trg.SignedBy = Src.RegistrertAvUserId,
      Trg.CaveIdList = Src.CaveIdList,
      Trg.StartReason = SUBSTRING(Src.StartReason,1,64),
      Trg.DoseCode = SUBSTRING(Src.DoseCode,1,32),
      Trg.Forskrivningskladd = ISNULL(Src.Forskrivningskladd,0),
      Trg.Seponeringskladd = ISNULL(Src.Seponeringskladd,0),
      Trg.SeponertAv = Src.SeponertAv,
      Trg.Seponeringsgrunn = Src.Seponeringsgrunn,
      Trg.RegistrertAv = Src.RegistrertAv,
      Trg.VarselSlvTypeV = Src.VarselSlvTypeV,
      Trg.VarselSlvTypeDN = Src.VarselSlvTypeDN,
      Trg.VarselSlvOverskrift = Src.VarselSlvOverskrift,
      Trg.VarselSlvTekst = Src.VarselSlvVarseltekst
  WHEN NOT MATCHED BY SOURCE
    AND ((Trg.StopAt IS NULL
    OR Trg.StopAt > GETDATE())
    AND Trg.PersonId = @Personid)
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

    DECLARE @ErrorMessage NVARCHAR(MAX),
            @ErrorSeverity INT,
            @ErrorState INT;
    SELECT @ErrorMessage = CONCAT( ERROR_MESSAGE(), ' Line ', ERROR_LINE()), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    EXEC Tools.AddTraceMessage @TraceMethod, 2, @ErrorMessage;
    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

  END CATCH;
END
GO

GRANT EXECUTE ON [eResept].[UpdateVIB] TO [FMUser]
GO