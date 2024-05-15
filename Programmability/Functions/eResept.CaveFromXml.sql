SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   FUNCTION [eResept].[CaveFromXml]( @XmlDoc XML ) 
RETURNS @CaveTable 
TABLE ( 
  CaveId uniqueidentifier NOT NULL PRIMARY KEY, RegistreringsDato DATE, HjelpestoffReaksjon BIT, GrunnlagForCAVE VARCHAR(MAX), Signatur VARCHAR(64), Inaktiv BIT,
  LegemiddelId VARCHAR(36), LegemiddelNavn VARCHAR(256), MerkevareATCKodeV VARCHAR(7), MerkevareATCKodeDN VARCHAR(128),
  VirkestoffId VARCHAR(36), VirkestoffNavn VARCHAR(128), ATCKodeV VARCHAR(7), ATCKodeDN VARCHAR(128),
  ReaksjonV TINYINT, ReaksjonDN VARCHAR(64), KildeV TINYINT, KildeDN VARCHAR(32), AlvorlighetsgradV CHAR(1), AlvorlighetsgradDN VARCHAR(16),
  SannsynlighetV TINYINT, SannsynlighetDN VARCHAR(16), Avkreftet BIT, OppdagetIkkeOppgitt BIT, OppdagetDato DATE, OppdagetAlder TINYINT, OppdagetUkjent BIT,
  Severity TINYINT, Relatedness TINYINT ) AS
BEGIN
  WITH XMLNAMESPACES( DEFAULT 'http://www.kith.no/xmlstds/eresept/forskrivningsmodul/epjapi/2019-07-26' )
  INSERT INTO @CaveTable
  SELECT
    cave.value('CAVEId[1]','uniqueidentifier') AS CAVEId,
    cave.value('RegisteringsDato[1]','DATE') AS RegistreringsDato,
    cave.value('HjelpestoffReaksjon[1]','BIT') AS HjelpestoffReaksjon,
    cave.value('GrunnlagForCAVE[1]','VARCHAR(MAX)' ) AS GrunnlagForCAVE,
    cave.value('Signatur[1]','VARCHAR(64)' ) AS Signatur,
    cave.value('Innaktiv[1]','BIT' ) AS Inaktiv,


    cave.value('LegemiddelMerkevare[1]/LegemiddelId[1]','VARCHAR(36)') AS LegemiddelId,
    cave.value('LegemiddelMerkevare[1]/LegemiddelNavn[1]','VARCHAR(256)' ) AS LegemiddelNavn,
    cave.value('LegemiddelMerkevare[1]/ATCKode[1]/@V','VARCHAR(7)') AS MerkevareATCKodeV,
    cave.value('LegemiddelMerkevare[1]/ATCKode[1]/@DN','VARCHAR(128)' ) AS MerkevareATCKodeDN,

    cave.value('Virkestoff[1]/VirkestoffId[1]','VARCHAR(36)' ) AS VirkestoffId,
    cave.value('Virkestoff[1]/VirkestoffNavn[1]','VARCHAR(256)' ) AS VirkestoffNavn,

    cave.value('ATC[1]/ATCKode[1]/@V','VARCHAR(7)' ) AS ATCKodeV,
    cave.value('ATC[1]/ATCKode[1]/@DN','VARCHAR(128)' ) AS ATCKodeDN,

    cave.value('Reaksjon[1]/@V','TINYINT' ) AS ReaksjonV,
    cave.value('Reaksjon[1]/@DN','VARCHAR(64)' ) AS ReaksjonDN,

    cave.value('Kilde[1]/@V','TINYINT' ) AS KildeV,
    cave.value('Kilde[1]/@DN','VARCHAR(32)' ) AS KildeDN,

    cave.value('Alvorlighetsgrad[1]/@V','CHAR(1)' ) AS AlvorlighetsgradV,
    cave.value('Alvorlighetsgrad[1]/@DN','VARCHAR(16)' ) AS AlvorlighetsgradDN,
    cave.value('Sannsynlighet[1]/@V','TINYINT') AS SannsynlighetV,
    cave.value('Sannsynlighet[1]/@DN','VARCHAR(16)' ) AS SannsynlighetDN,
    cave.value('Avkreftet[1]','BIT' ) AS Avkreftet, 

    cave.value('Oppdaget[1]/IkkeOppgitt[1]','BIT' ) AS OppdagetIkkeOppgitt,
    cave.value('Oppdaget[1]/Dato[1]','DATE' ) AS OppdagetDato,
    cave.value('Oppdaget[1]/Alder[1]','TINYINT' ) AS OppdagetAlder,
    cave.value('Oppdaget[1]/Ukjent[1]','BIT' ) AS OppdagetUkjent,

    -- Konverteringer til kodeverk som brukes i FastTrak for (se dbo.MetaSeverity og dbo.MetaRelatedness) 

    CASE cave.value('Alvorlighetsgrad[1]/@V','VARCHAR(1)' ) 
      WHEN 'K' THEN 4
      WHEN 'A' THEN 3
      WHEN 'M' THEN 2
      ELSE 0
    END AS Severity,
    CASE cave.value('Sannsynlighet[1]/@V','INT' ) 
    WHEN '1' THEN 3
      WHEN '2' THEN 4
      WHEN '3' THEN 5
      ELSE 0
    END AS Relatedness
  FROM @XmlDoc.nodes( 'LesCaveSvar/CAVE' ) AS xd(cave);
  RETURN;
END;
GO