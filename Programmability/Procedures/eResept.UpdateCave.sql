SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[UpdateCave] ( @PersonId INT, @XmlString NVARCHAR(MAX) ) AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @TraceMethod VARCHAR(50) = 'eResept.UpdateCave';
  DECLARE @TraceMessage VARCHAR(MAX);

  SELECT @TraceMessage = CONCAT( 'Enter eResept.UpdateCave: PersonId = ', @PersonId );

  EXEC Tools.AddTraceMessage @TraceMethod, 0, @TraceMessage;
  EXEC Tools.AddTraceMessage @TraceMethod, 0, @XmlString;

  -- Ser ikke ut som namespaces blir fjernet før vi får xml-dokumentet fra FastTrak, så bare fjerner dem her.

  DECLARE @Xml NVARCHAR(MAX) = @XmlString;
  SELECT @Xml = REPLACE(@Xml, 'xmlns="http://www.kith.no/xmlstds/eresept/forskrivningsmodul/epjapi/2019-07-26"', '');

  -- Konverterer til XML-type, og legger inn i en tabell
  PRINT ' Copying data from XML to @DrugReactionsXml temp table.';

  DECLARE @DrugReactionsXml TABLE (
    XML XML NOT NULL
  );

  INSERT INTO @DrugReactionsXml
    VALUES (CAST(@Xml AS XML));

  -- Dette er det vi skal hente ut fra XML-dokumentet
  DECLARE @DrugReactions TABLE (
    CaveId VARCHAR(40) NOT NULL,
    HjelpestoffReaksjon BIT NULL,
    GrunnlagForCAVE VARCHAR(MAX) NULL,
    RegistreringsDato DATETIME NULL,
    Signatur VARCHAR(MAX) NULL,
    Inaktiv BIT NULL,
    LegemiddelId VARCHAR(MAX) NULL,
    LegemiddelNavn VARCHAR(MAX) NULL,
    ATCKodeV VARCHAR(MAX) NULL,
    ATCKodeDN VARCHAR(MAX) NULL,
    VirkestoffId VARCHAR(MAX) NULL,
    VirkestoffNavn VARCHAR(MAX) NULL,
    VirkestoffIdAlt VARCHAR(MAX) NULL,
    VirkestoffNavnAlt VARCHAR(MAX) NULL,
    ReaksjonDN VARCHAR(MAX) NULL,
    ReaksjonV VARCHAR(MAX) NULL,
    KildeV VARCHAR(MAX) NULL,
    KildeDN VARCHAR(MAX) NULL,
    AlvorlighetsgradV VARCHAR(MAX) NULL,
    AlvorlighetsgradDN VARCHAR(MAX) NULL,
    SannsynlighetV VARCHAR(MAX) NULL,
    SannsynlighetDN VARCHAR(MAX) NULL,
    Avkreftet BIT NULL,
    Oppdaget_IkkeOppgitt BIT NULL,
    Oppdaget_Dato DATETIME NULL,
    Oppdaget_Alder VARCHAR(MAX) NULL,
    Oppdaget_Ukjent BIT NULL
  );

  PRINT ' Copying data from XML to @DrugReactions temp table.';

  INSERT INTO @DrugReactions( CaveId, HjelpestoffReaksjon, GrunnlagForCAVE, RegistreringsDato, Signatur, Inaktiv, LegemiddelId, LegemiddelNavn,
  ATCKodeV, ATCKodeDN, VirkestoffId, VirkestoffNavn, VirkestoffIdAlt, VirkestoffNavnAlt, ReaksjonDN, ReaksjonV, KildeV, KildeDN, AlvorlighetsgradV,
  AlvorlighetsgradDN, SannsynlighetV, SannsynlighetDN, Avkreftet, Oppdaget_IkkeOppgitt, Oppdaget_Dato, Oppdaget_Alder, Oppdaget_Ukjent )
    SELECT
      -- Cave ID
      CAST(c.query('data(CAVEId)') AS NVARCHAR(50)) AS CaveId,

      -- HjelpestoffReaksjon?
      CONVERT(BIT, CAST(c.query('data(HjelpestoffReaksjon)') AS NVARCHAR(MAX))) AS HjelpestoffReaksjon,

      -- GrunnlagForCAVE
      CAST(c.query('data(GrunnlagForCAVE)') AS NVARCHAR(MAX)) AS GrunnlagForCAVE,

      -- RegistreringsDato
      CONVERT(DATETIME, CAST(c.query('data(RegisteringsDato)') AS NVARCHAR(MAX))) AS RegistreringsDato,

      -- Signatur
      NULLIF(CAST(c.query('data(Signatur)') AS NVARCHAR(MAX)), '') AS Signatur,

      -- Inaktiv
      CONVERT(BIT, CAST(c.query('data(Innaktiv)') AS NVARCHAR(MAX))) AS Inaktiv,

      -- LegemiddelId
      NULLIF(CAST(c.query('data(LegemiddelMerkevare/LegemiddelId)') AS NVARCHAR(MAX)), '') AS LegemiddelId,

      -- LegemiddelNavn
      NULLIF(CAST(c.query('data(LegemiddelMerkevare/LegemiddelNavn)') AS NVARCHAR(MAX)), '') AS LegemiddelNavn,

      -- ATCKodeV
      NULLIF(CAST(c.query('data(LegemiddelMerkevare/ATCKode/@V)') AS NVARCHAR(MAX)), '') AS ATCKodeV,

      -- ATCKodeDN
      NULLIF(CAST(c.query('data(LegemiddelMerkevare/ATCKode/@DN)') AS NVARCHAR(MAX)), '') AS ATCKodeDN,

      -- VirkestoffId
      NULLIF(CAST(c.query('data(LegemiddelMerkevare/Virkestoff/VirkestoffId)') AS NVARCHAR(MAX)), '') AS VirkestoffId,

      -- VirkestoffNavn
      NULLIF(CAST(c.query('data(LegemiddelMerkevare/Virkestoff/VirkestoffNavn)') AS NVARCHAR(MAX)), '') AS VirkestoffNavn,

      -- VirkestoffIdAlt
      NULLIF(CAST(c.query('data(Virkestoff/VirkestoffId)') AS NVARCHAR(MAX)), '') AS VirkestoffIdAlt,

      -- VirkestoffNavnAlt
      NULLIF(CAST(c.query('data(Virkestoff/VirkestoffNavn)') AS NVARCHAR(MAX)), '') AS VirkestoffNavnAlt,

      -- ReaksjonDN
      NULLIF(CAST(c.query('data(Reaksjon/@DN)') AS NVARCHAR(MAX)), '') AS ReaksjonDN,

      -- ReaksjonV
      NULLIF(CAST(c.query('data(Reaksjon/@V)') AS NVARCHAR(MAX)), '') AS ReaksjonV,

      -- KildeV
      NULLIF(CAST(c.query('data(Kilde/@V)') AS NVARCHAR(MAX)), '') AS KildeV,

      -- KildeDN
      NULLIF(CAST(c.query('data(Kilde/@DN)') AS NVARCHAR(MAX)), '') AS KildeDN,

      -- AlvorlighetsgradV
      CASE CAST(c.query('data(Alvorlighetsgrad/@V)') AS NVARCHAR(MAX))
        WHEN 'K' THEN 8
        WHEN 'A' THEN 7
        WHEN 'M' THEN 6
        ELSE 0
      END AS AlvorlighetsgradV,

      -- AlvorlighetsgradDN
      NULLIF(CAST(c.query('data(Alvorlighetsgrad/@DN)') AS NVARCHAR(MAX)), '') AS AlvorlighetsgradDN,

      -- SannsynlighetV
      NULLIF(CAST(c.query('data(Sannsynlighet/@V)') AS NVARCHAR(MAX)), '') AS SannsynlighetV,

      -- SannsynlighetDN
      NULLIF(CAST(c.query('data(Sannsynlighet/@DN)') AS NVARCHAR(MAX)), '') AS SannsynlighetDN,

      -- Avkreftet
      CONVERT(BIT, CAST(c.query('data(Avkreftet)') AS NVARCHAR(MAX))) AS Avkreftet,

      -- Oppdaget_IkkeOppgitt
      CONVERT(BIT, CAST(c.query('data(Oppdaget/IkkeOppgitt)') AS NVARCHAR(MAX))) AS Oppdaget_IkkeOppgitt,

      -- Oppdaget_Dato
      CONVERT(DATETIME, CAST(c.query('data(Oppdaget/Dato)') AS NVARCHAR(MAX))) AS Oppdaget_Dato,

      -- Oppdaget_Alder
      NULLIF(CAST(c.query('data(Oppdaget/Alder)') AS NVARCHAR(MAX)), '') AS Oppdaget_Alder,

      -- Oppdaget_Ukjent
      CONVERT(BIT, CAST(c.query('data(Oppdaget/Ukjent)') AS NVARCHAR(MAX))) AS Oppdaget_Ukjent
    FROM @DrugReactionsXml r
    CROSS APPLY XML.nodes('LesCaveSvar/CAVE') x (c);

  -- Dersom det er virkestoff og ikke legemiddel så skal virkestoffnavnet inn i LegemiddelNavn
  UPDATE @DrugReactions
  SET VirkestoffId = VirkestoffIdAlt, LegemiddelNavn = VirkestoffNavnAlt
  WHERE VirkestoffIdAlt IS NOT NULL
  AND VirkestoffId IS NULL;

  SELECT @TraceMessage = 'No of rows found in XML: ' + CAST(COUNT(*) AS VARCHAR)
  FROM @DrugReactions;

  PRINT ' Add trace message.';

  EXEC Tools.AddTraceMessage @TraceMethod, 0, @TraceMessage

  PRINT ' Merging from @DrugReactions temp table to dbo.DrugReaction.';

  -- Oppdater DrugReaction: Legg inn dersom den ikke finnes, oppdater dersom den finnes, slett dersom det finnes noen som vi ikke får tilbake.
  MERGE
  INTO dbo.DrugReaction AS Trg USING @DrugReactions AS Src
  ON (Trg.CaveId = Src.CaveId)
  WHEN MATCHED
    THEN UPDATE
      SET Trg.DRDate = Src.RegistreringsDato,
      Trg.ATC = Src.ATCKodeV,
      Trg.DrugName = SUBSTRING( COALESCE(Src.VirkestoffNavn, Src.LegemiddelNavn),1, 64 ),
      Trg.Severity = Src.AlvorlighetsgradV,
      Trg.Relatedness = Src.SannsynlighetV,
      Trg.DescriptiveText = Src.ReaksjonDN,
      Trg.VirkestoffId = NULLIF(Src.VirkestoffId, ''),
      Trg.LegemiddelId = NULLIF(Src.LegemiddelId, ''),
      Trg.UpdatedAt = GETDATE(),
      Trg.UpdatedBy = USER_ID(),
      Trg.HjelpestoffReaksjon = Src.HjelpestoffReaksjon,
      Trg.GrunnlagForCAVE = Src.GrunnlagForCAVE,
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
      Trg.Oppdaget_Alder = Src.Oppdaget_Alder,
      Trg.Oppdaget_IkkeOppgitt = Src.Oppdaget_IkkeOppgitt,
      Trg.Oppdaget_Dato = Src.Oppdaget_Dato,
      Trg.Oppdaget_Ukjent = Src.Oppdaget_Ukjent,
      Trg.DeletedAt = NULL,
      Trg.DeletedBy = NULL
  WHEN NOT MATCHED BY TARGET
    THEN INSERT 
      (
        DRDate, DRFuzzy, PersonId, ATC, 
        DrugName, 
        Severity, Relatedness, DescriptiveText,
        CaveId, Resolved, VirkestoffId, LegemiddelId, CreatedAt, CreatedBy, HjelpestoffReaksjon,
        GrunnlagForCAVE, Signatur, LegemiddelNavn, VirkestoffNavn, 
        ReaksjonV, ReaksjonDN,
        KildeV, KildeDN, 
        AlvorlighetsgradV, AlvorlighetsgradDN, SannsynlighetV, SannsynlighetDN, Avkreftet,
        Oppdaget_IkkeOppgitt, Oppdaget_Dato, Oppdaget_Alder, Oppdaget_Ukjent
        )
      VALUES 
        ( 
          Src.RegistreringsDato, 0, @PersonId, Src.ATCKodeV,
          SUBSTRING(COALESCE(Src.VirkestoffNavn, Src.LegemiddelNavn),1,64), 
          Src.AlvorlighetsgradV, Src.SannsynlighetV, Src.ReaksjonDN,
          Src.CaveId, 4, Src.VirkestoffId, Src.LegemiddelId, GETDATE(), USER_ID(), src.HjelpestoffReaksjon,
          Src.GrunnlagForCAVE, src.Signatur, SUBSTRING(Src.LegemiddelNavn,1,64), SUBSTRING( Src.VirkestoffNavn,1,64 ),
          Src.ReaksjonV, Src.ReaksjonDN,
          Src.KildeV, Src.KildeDN, 
          Src.AlvorlighetsgradV, Src.AlvorlighetsgradDN, Src.SannsynlighetV, Src.SannsynlighetDN, Src.Avkreftet,
          Src.Oppdaget_IkkeOppgitt, Src.Oppdaget_Dato, Src.Oppdaget_Alder, Src.Oppdaget_Ukjent
        )
  WHEN NOT MATCHED BY SOURCE
    AND (Trg.PersonId = @Personid AND trg.DeletedBy IS NULL)
    THEN UPDATE SET trg.DeletedAt = GETDATE(), trg.DeletedBy = USER_ID();

  PRINT ' Inserting into @GrunnlagForCaveTab.';

  SELECT @TraceMessage = 'No of rows processed in merge: ' + CAST(@@ROWCOUNT AS VARCHAR);

  EXEC Tools.AddTraceMessage @TraceMethod, 0, @TraceMessage

  -- Må oppdatere CAVE i DrugTreatment. I DrugTreatment er det lagt inn en eller flere guid-er for bivirkninger i CaveIdList (separert med mellomrom)
  -- Henter inn CAVE i en temporær tabell (for å slippe å ha cursor på en "ordentlig" tabell)
  -- Looper på den @DrugReaction-tabellen og oppdaterer fra @GrunnlagForCave-tabellen.

  DECLARE @GrunnlagForCaveTab TABLE (
    TreatId INT,
    CaveIdList VARCHAR(MAX),
    CAVE VARCHAR(MAX)
  );

  INSERT INTO @GrunnlagForCaveTab
    SELECT DISTINCT b.TreatId, b.CaveIdList, 'Grunnlag for CAVE registrering:'
    FROM @DrugReactions a
    JOIN dbo.DrugTreatment b ON b.CaveIdList LIKE '%' + a.CaveId + '%';


  DECLARE @BR VARCHAR(2) = CHAR(13) + CHAR(10);
  DECLARE @TreatId VARCHAR(MAX);
  DECLARE @GrunnlagForCAVE VARCHAR(MAX) = '';

  DECLARE treat_cur CURSOR FAST_FORWARD FOR
  SELECT b.TreatId, COALESCE(a.VirkestoffNavn, a.LegemiddelNavn) + ': ' + a.GrunnlagForCAVE AS GrunnlagForCAVE
  FROM @DrugReactions a
  JOIN @GrunnlagForCaveTab b
    ON b.CaveIdList LIKE '%' + a.CaveId + '%';

  OPEN treat_cur;
  FETCH NEXT FROM treat_cur INTO @TreatId, @GrunnlagForCAVE;

  SELECT @TraceMessage = 'Første fetch: ' + CONVERT(VARCHAR(MAX), @@FETCH_STATUS) + ' ' + @TreatId + ' ' + @GrunnlagForCAVE
  EXEC Tools.AddTraceMessage @TraceMethod, 0, @TraceMessage

  WHILE @@FETCH_STATUS = 0
  BEGIN
    SELECT @TraceMessage = 'Grunnlag for CAVE:' + @TreatId + '|' + @GrunnlagForCAVE
    EXEC Tools.AddTraceMessage @TraceMethod, 0, @TraceMessage

    UPDATE @GrunnlagForCaveTab
    SET CAVE = CAVE + @BR + @GrunnlagForCAVE
    WHERE TreatId = @TreatId;
    FETCH NEXT FROM treat_cur INTO @TreatId, @GrunnlagForCAVE;

    SELECT @TraceMessage = 'FETCH_STATUS=' + CONVERT(VARCHAR(MAX), @@FETCH_STATUS);
    EXEC Tools.AddTraceMessage @TraceMethod, 0, @TraceMessage
  END;

  CLOSE treat_cur;
  DEALLOCATE treat_cur;

  PRINT 'Merging from @GrunnlagForCaveTab to DrugTreatment';

  MERGE
  INTO dbo.DrugTreatment AS Trg USING @GrunnlagForCaveTab AS Src
  ON (Trg.TreatId = Src.TreatId)
  WHEN MATCHED
    THEN UPDATE
      SET Trg.CAVE = Src.CAVE;

  SELECT @TraceMessage = 'No of rows processed in DrugTreatment-merge: ' + CAST(@@ROWCOUNT AS VARCHAR)
  EXEC Tools.AddTraceMessage @TraceMethod, 0, @TraceMessage
  UPDATE dbo.DrugReaction 
     SET Oppdaget = 'Ikke oppgitt'
   WHERE Oppdaget_IkkeOppgitt = 1
     AND PersonId = @PersonId;

  UPDATE dbo.DrugReaction 
     SET Oppdaget = 'Ikke kjent'
   WHERE Oppdaget_Ukjent = 1
     AND PersonId = @PersonId;

  UPDATE dbo.DrugReaction 
     SET Oppdaget = 'Først oppdaget ' + FORMAT(Oppdaget_Dato, 'dd.MM.yyyy')
   WHERE Oppdaget_Dato > '1900-01-01'
     AND PersonId = @PersonId;

  UPDATE dbo.DrugReaction 
     SET Oppdaget = 'Først oppdaget ved ' + CAST(Oppdaget_Alder AS VARCHAR)
   WHERE Oppdaget_Alder IS NOT NULL 
     AND PersonId = @PersonId;

  UPDATE dbo.DrugReaction
     SET Oppdaget = ''
     WHERE COALESCE(Oppdaget_IkkeOppgitt,0) = 0
       AND COALESCE(Oppdaget_Ukjent,0) = 0
       AND COALESCE(Oppdaget_Dato,'1900-01-01') = '1900-01-01'
       AND COALESCE(Oppdaget_Alder,-1) = -1
       AND PersonId = @PersonId;
  SELECT *
  FROM dbo.DrugReaction dr
  WHERE dr.PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [eResept].[UpdateCave] TO [FastTrak]
GO