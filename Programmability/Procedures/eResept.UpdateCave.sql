SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[UpdateCave] ( @PersonId INT, @XmlString NVARCHAR(MAX) ) AS
BEGIN

  SET NOCOUNT ON;
  BEGIN TRY 

  -- Ser ikke ut som namespaces blir fjernet før vi får xml-dokumentet fra FastTrak, så bare fjerner dem her.

  SELECT @XmlString = REPLACE(@XmlString, 'xmlns="http://www.kith.no/xmlstds/eresept/forskrivningsmodul/epjapi/2019-07-26"', '');

  -- Konverterer til XML-type, og legger inn i en tabell

  PRINT ' Copying data from XML to @DrugReactionsXml temp table.';

  DECLARE @DrugReactionsXml TABLE (
    XML XML NOT NULL
  );

  INSERT INTO @DrugReactionsXml
    VALUES (CAST(@XmlString AS XML));

  -- Dette er det vi skal hente ut fra XML-dokumentet

  DECLARE @FmDrugReactions TABLE (
    CaveId                      VARCHAR(40) NOT NULL PRIMARY KEY,
    HjelpestoffReaksjon         BIT,
    GrunnlagForCAVE             VARCHAR(MAX),
    RegistreringsDato           DATE,
    Signatur                    VARCHAR(MAX),
    Inaktiv                     BIT,
    LegemiddelId                VARCHAR(40),  -- LegemiddelMerkevare CAVE (også neste 5)
    LegemiddelNavn              VARCHAR(256),
    MerkevareATCKodeV           VARCHAR(7),
    MerkevareATCKodeDN          VARCHAR(256),
    MerkevareVirkestoffIdList   VARCHAR(MAX), 
    MerkevareVirkestoffNavnList VARCHAR(MAX),
    VirkestoffId                VARCHAR(40),  -- Virkestoff CAVE (også neste)
    VirkestoffNavn              VARCHAR(256),
    ATCKodeV                    VARCHAR(7),  -- ATC CAVE (også neste)
    ATCKodeDN                   VARCHAR(256),
    ReaksjonV                   TINYINT,      -- Resten brukes for alle
    ReaksjonDN                  VARCHAR(MAX),
    KildeV                      TINYINT,
    KildeDN                     VARCHAR(MAX),
    AlvorlighetsgradV           CHAR(1),
    AlvorlighetsgradDN          VARCHAR(MAX),
    SannsynlighetV              TINYINT,
    SannsynlighetDN             VARCHAR(MAX),
    Avkreftet                   BIT,
    OppdagetIkkeOppgitt         BIT,
    OppdagetDato                DATE,
    OppdagetAlder               TINYINT,
    OppdagetUkjent              BIT,
    -- FastTrak koder
    Severity                    TINYINT,
    Relatedness                 TINYINT
  );

  PRINT ' Copying data from XML to @DrugReactions temp table.';

  INSERT INTO @FmDrugReactions
    ( 
      CaveId, RegistreringsDato, HjelpestoffReaksjon, GrunnlagForCAVE, Signatur, Inaktiv, 
      LegemiddelId, LegemiddelNavn, MerkevareATCKodeV, MerkevareATCKodeDN, MerkevareVirkestoffIdList, MerkevareVirkestoffNavnList, 
      VirkestoffId, VirkestoffNavn, ATCKodeV, ATCKodeDN,
      ReaksjonV, ReaksjonDN, KildeV, KildeDN, AlvorlighetsgradV, AlvorlighetsgradDN, SannsynlighetV, SannsynlighetDN, 
      Avkreftet, OppdagetIkkeOppgitt, OppdagetDato, OppdagetAlder, OppdagetUkjent, 
      Severity, Relatedness
    )
    SELECT
      CAST(c.query('data(CAVEId)') AS                                        VARCHAR(40))  AS CaveId,
      CAST(c.query('data(RegisteringsDato)') AS                              VARCHAR(10))  AS RegistreringsDato,
      CAST(c.query('data(HjelpestoffReaksjon)') AS                           VARCHAR(5))   AS HjelpestoffReaksjon,
      CAST(c.query('data(GrunnlagForCAVE)') AS                               VARCHAR(MAX)) AS GrunnlagForCAVE,
      CAST(c.query('data(Signatur)') AS                                      VARCHAR(MAX)) AS Signatur,

      CAST(c.query('data(Innaktiv)') AS                                      VARCHAR(5))   AS Inaktiv,
      CAST(c.query('data(LegemiddelMerkevare/LegemiddelId)') AS              VARCHAR(40))  AS LegemiddelId,
      CAST(c.query('data(LegemiddelMerkevare/LegemiddelNavn)') AS            VARCHAR(255)) AS LegemiddelNavn,
      CAST(c.query('data(LegemiddelMerkevare/ATCKode/@V)') AS                VARCHAR(7))   AS MerkevareATCKodeV,
      CAST(c.query('data(LegemiddelMerkevare/ATCKode/@DN)') AS               VARCHAR(255)) AS MerkevareATCKodeDN,

      CAST(c.query('data(LegemiddelMerkevare/Virkestoff/VirkestoffId)') AS   VARCHAR(MAX)) AS MerkevareVirkestoffIdList,
      CAST(c.query('data(LegemiddelMerkevare/Virkestoff/VirkestoffNavn)') AS VARCHAR(MAX)) AS MerkevareVirkestoffNavnList,
      CAST(c.query('data(Virkestoff/VirkestoffId)') AS                       VARCHAR(40))  AS VirkestoffId,
      CAST(c.query('data(Virkestoff/VirkestoffNavn)') AS                     VARCHAR(256)) AS VirkestoffNavn,
      CAST(c.query('data(ATC/ATCKode/@V)') AS                                VARCHAR(7))   AS ATCKodeV,

      CAST(c.query('data(ATC/ATCKode/@DN)') AS                               VARCHAR(256)) AS ATCKodeDN,
      CAST(c.query('data(Reaksjon/@V)') AS                                   VARCHAR(3))   AS ReaksjonV,
      CAST(c.query('data(Reaksjon/@DN)') AS                                  VARCHAR(128)) AS ReaksjonDN,
      CAST(c.query('data(Kilde/@V)') AS                                      CHAR(1))      AS KildeV,
      CAST(c.query('data(Kilde/@DN)') AS                                     VARCHAR(128)) AS KildeDN,

      CAST(c.query('data(Alvorlighetsgrad/@V)') AS                           CHAR(1))      AS AlvorlighetsgradV,
      CAST(c.query('data(Alvorlighetsgrad/@DN)') AS                          VARCHAR(16))  AS AlvorlighetsgradDN,
      CAST(c.query('data(Sannsynlighet/@V)') AS                              CHAR(1))      AS SannsynlighetV,
      CAST(c.query('data(Sannsynlighet/@DN)') AS                             VARCHAR(16))  AS SannsynlighetDN,
      CAST(c.query('data(Avkreftet)') AS                                     VARCHAR(5))   AS Avkreftet, 

      CAST(c.query('data(Oppdaget/IkkeOppgitt)') AS                          VARCHAR(5))   AS OppdagetIkkeOppgitt,
      CAST(c.query('data(Oppdaget/Dato)') AS                                 VARCHAR(10))  AS OppdagetDato,
      CAST(c.query('data(Oppdaget/Alder)') AS                                VARCHAR(3))   AS OppdagetAlder,
      CAST(c.query('data(Oppdaget/Ukjent)') AS                               VARCHAR(5))   AS OppdagetUkjent,

      -- Konverteringer til kodeverk som brukes i FastTrak for (se dbo.MetaSeverity og dbo.MetaRelatedness)

      CASE CAST(c.query('data(Alvorlighetsgrad/@V)') AS                      VARCHAR(MAX))
        WHEN 'K' THEN 4
        WHEN 'A' THEN 3
        WHEN 'M' THEN 2
        ELSE 0
      END                                                                                  AS Severity,
      CASE CAST(c.query('data(Sannsynlighet/@V)') AS                         VARCHAR(MAX))
        WHEN '1' THEN 3
        WHEN '2' THEN 4
        WHEN '3' THEN 5
        ELSE 0
      END                                                                                  AS Relatedness

    FROM @DrugReactionsXml r
    CROSS APPLY XML.nodes('LesCaveSvar/CAVE') x (c);

  -- Bli kvitt strenger som blir til '' i stedet for NULL under CAST operasjonene over.

  UPDATE @FmDrugReactions SET 
    GrunnlagForCAVE = NULLIF(GrunnlagForCave, '' ), LegemiddelId = NULLIF(LegemiddelId, ''), LegemiddelNavn = NULLIF(Legemiddelnavn,''), 
    MerkevareATCKodeV = NULLIF(MerkevareATCKodeV,''), MerkevareATCKodeDN = NULLIF(MerkevareATCKodeDN,''), MerkevareVirkestoffIdList = NULLIF(MerkevareVirkestoffIdList,''), MerkevareVirkestoffNavnList = NULLIF(MerkevareVirkestoffNavnList,''),
    VirkestoffId = NULLIF(VirkestoffId,''), VirkestoffNavn = NULLIF(VirkestoffNavn,''), 
    ATCKodeV = NULLIF(ATCKodeV,''), ATCKodeDN = NULLIF(ATCKodeDN,''),
    SannsynlighetDN = NULLIF(SannsynlighetDN,''), AlvorlighetsgradV = NULLIF(AlvorlighetsGradV,''), AlvorlighetsgradDN = NULLIF(AlvorlighetsGradDN,'');
  UPDATE @FmDrugReactions SET OppdagetAlder = NULL, OppdagetDato = NULL, OppdagetUkjent = 1 WHERE OppdagetIkkeOppgitt = 1;

  PRINT ' Merging from @DrugReactions temp table to dbo.DrugReaction.';

  -- Oppdater DrugReaction: Legg inn dersom den ikke finnes, oppdater dersom den finnes, slett dersom det finnes noen som vi ikke får tilbake.

  MERGE
  INTO dbo.DrugReaction AS Trg USING @FmDrugReactions AS Src
  ON (Trg.CaveId = Src.CaveId AND Trg.PersonId = @PersonId )
  WHEN MATCHED
    THEN UPDATE
      SET Trg.DRDate = Src.RegistreringsDato,
      Trg.ATC = COALESCE( Src.MerkevareATCKodeV, Src.AtcKodeV ),
      Trg.ATCName = COALESCE( Src.MerkevareATCKodeDN, Src.ATCKodeDN ),
      Trg.DrugName = COALESCE( Src.LegemiddelNavn, Src.VirkestoffNavn, Src.ATCKodeDN ),
      Trg.DescriptiveText = Src.GrunnlagForCAVE,
      Trg.VirkestoffId = Src.VirkestoffId,
      Trg.LegemiddelId = Src.LegemiddelId,
      Trg.UpdatedAt = GETDATE(),
      Trg.UpdatedBy = USER_ID(),
      Trg.HjelpestoffReaksjon = Src.HjelpestoffReaksjon,
      Trg.Signatur = Src.Signatur,
      Trg.LegemiddelNavn = Src.LegemiddelNavn,
      Trg.VirkestoffNavn = Src.VirkestoffNavn,
      Trg.ReaksjonV = Src.ReaksjonV,
      Trg.ReaksjonDN = Src.ReaksjonDN,
      Trg.KildeV = Src.KildeV,
      Trg.KildeDN = Src.KildeDN,
      Trg.AlvorlighetsgradV = Src.AlvorlighetsgradV,
      Trg.AlvorlighetsgradDN = Src.AlvorlighetsgradDN,
      Trg.SannsynlighetV = Src.SannsynlighetV,
      Trg.SannsynlighetDN = Src.SannsynlighetDN,
      Trg.Avkreftet = Src.Avkreftet,
      Trg.Oppdaget_Alder = Src.OppdagetAlder,
      Trg.Oppdaget_IkkeOppgitt = Src.OppdagetIkkeOppgitt,
      Trg.Oppdaget_Dato = Src.OppdagetDato,
      Trg.Oppdaget_Ukjent = Src.OppdagetUkjent,
      Trg.Severity = Src.Severity,
      Trg.Relatedness = Src.Relatedness,
      Trg.DeletedAt = NULL,
      Trg.DeletedBy = NULL
  WHEN NOT MATCHED BY TARGET
    THEN INSERT 
      (
        DRDate, DRFuzzy, PersonId, 
        ATC, DrugName, ATCName, Severity, Relatedness, DescriptiveText,
        CaveId, VirkestoffId, LegemiddelId, CreatedAt, CreatedBy, HjelpestoffReaksjon,
        Signatur, LegemiddelNavn, VirkestoffNavn, 
        ReaksjonV, ReaksjonDN, KildeV, KildeDN, AlvorlighetsgradV, AlvorlighetsgradDN, SannsynlighetV, SannsynlighetDN, 
        Avkreftet, Oppdaget_IkkeOppgitt, Oppdaget_Dato, Oppdaget_Alder, Oppdaget_Ukjent
        )
      VALUES 
        ( 
          Src.RegistreringsDato, 0, @PersonId, 
          COALESCE( Src.MerkevareATCKodeV, Src.ATCKodeV ),
          COALESCE( Src.LegemiddelNavn, Src.VirkestoffNavn, src.ATCKodeDN ), 
          COALESCE( Src.MerkevareATCKodeDN, Src.ATCKodeDN ),
          Src.Severity, Src.Relatedness, Src.GrunnlagForCave,
          Src.CaveId, Src.VirkestoffId, Src.LegemiddelId, GETDATE(), USER_ID(), src.HjelpestoffReaksjon,
          src.Signatur, SUBSTRING(Src.LegemiddelNavn,1,64), SUBSTRING( Src.VirkestoffNavn,1,64 ),
          Src.ReaksjonV, Src.ReaksjonDN, Src.KildeV, Src.KildeDN, Src.AlvorlighetsgradV, Src.AlvorlighetsgradDN, Src.SannsynlighetV, Src.SannsynlighetDN, 
          Src.Avkreftet, Src.OppdagetIkkeOppgitt, Src.OppdagetDato, Src.OppdagetAlder, Src.OppdagetUkjent
        )
  WHEN NOT MATCHED BY SOURCE
    AND ( Trg.PersonId = @Personid AND trg.DeletedBy IS NULL )
    THEN UPDATE SET trg.DeletedAt = GETDATE(), trg.DeletedBy = USER_ID();

  EXEC eResept.UpdateDrugTreatmentCave @PersonId;

    IF @@TRANCOUNT > 0 COMMIT TRANSACTION;

  END TRY
  BEGIN CATCH
    DECLARE @ErrorMessage VARCHAR(512);
    SET @ErrorMessage = ERROR_MESSAGE();
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    RAISERROR( @ErrorMessage, 16, 1 );
    RETURN -1;
  END CATCH;
END
GO