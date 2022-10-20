SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE   FUNCTION [eResept].[DrugTreatmentFromXml]( @PersonId INT, @XmlDoc XML ) 
RETURNS @DrugTreatment TABLE( 
    LibId uniqueidentifier NOT NULL PRIMARY KEY, 
    ATC VARCHAR(7),
    DrugName VARCHAR(256) NOT NULL, DrugForm VARCHAR(64), 
    Strength FLOAT, StrengthUnit VARCHAR(24),
    TreatType CHAR(1) NOT NULL, PackType CHAR(1) NOT NULL,
    DoseCode VARCHAR(32), RxText VARCHAR(MAX),
    StartAt DATE,  RegistrertAv VARCHAR(64),
    Forskrivningskladd BIT NOT NULL, Seponeringskladd BIT NOT NULL, 
    StopAt DATETIME, Seponeringsdato DATE, Seponeringsgrunn VARCHAR(64),
    DobbeltForskrivningsvarsel VARCHAR(MAX),
    Bruksomrade VARCHAR(128), DosVeiledEnkel VARCHAR(1024)
    ) AS
 BEGIN
    INSERT INTO @DrugTreatment
    SELECT 
      a.LibId, a.Varenavn AS DrugName, 
      ISNULL( LegemiddelPakningATC, LegemiddelVirkestoffATC ) AS ATC,
      a.Legemiddelform AS DrugForm,
      TRY_CONVERT( FLOAT, SUBSTRING( StrengthStr, 1, PatIndexStrength - 1 ) ) AS Strength,
        SUBSTRING( StrengthStr, PatIndexStrength, 24 ) AS StrengthUnit,
      SUBSTRING( 'FKB', Bruk, 1 ) AS TreatType, AdministreringType AS PackType,
      Kortdose AS DoseCode, DosVeiledEnkel AS RxText,
      Institueringsdato AS StartAt, RegistrertAv,
      Forskrivningskladd, Seponeringskladd,
      Seponeringstidspunkt AS StopAt, Seponeringsdato, Seponeringsgrunn AS StopReason,
      DobbeltForskrivningsvarsel,
      Bruksomrade AS StartReason, DosVeiledEnkel AS RxText
    FROM
    (
    SELECT 
      rdl.value( '../LibId[1]', 'uniqueidentifier' ) AS LibId,
      rdl.value( '../Varenavn[1]', 'VARCHAR(256)' ) AS Varenavn,
      rdl.value( '../Legemiddelform[1]', 'VARCHAR(64)' ) AS Legemiddelform,
      rdl.value( '../Styrke[1]', 'VARCHAR(24)' ) AS StrengthStr, -- Temporary
      PATINDEX('%[^0-9,.]%', rdl.value('../Styrke[1]', 'VARCHAR(24)' ) ) AS PatIndexStrength, -- Temporary
      rdl.value( 'Forskrivning[1]/Bruk[1]/@V', 'INT' ) AS Bruk, -- Transforms to TreatType
      rdl.value( '../Administrering[1]/Type[1]', 'CHAR(1)' ) AS AdministreringType, -- Equal to PackType
      rdl.value( '../InstitueringsDato[1]', 'DATE' ) AS InstitueringsDato,
      rdl.value( '../SeponeringsInfomasjon[1]/Seponeringsdato[1]', 'DATE' ) AS Seponeringsdato,
      rdl.value( '../SeponeringsInfomasjon[1]/Seponeringstidspunkt[1]', 'DATETIME' ) AS Seponeringstidspunkt,
      rdl.value( '../SeponeringsInfomasjon[1]/Seponeringsgrunn[1]', 'VARCHAR(64)' ) AS Seponeringsgrunn,
      rdl.value( '../SeponeringsInfomasjon[1]/SeponertAv[1]', 'VARCHAR(60)' ) AS SeponertAv,
      ISNULL( rdl.value( '../Kladd[1]', 'BIT' ), 0 ) AS Forskrivningskladd,
      ISNULL( rdl.value( '../Seponeringskladd[1]', 'BIT' ), 0 ) AS Seponeringskladd,
      rdl.value( '../RegistrertAv[1]', 'VARCHAR(60)' ) AS RegistrertAv,
      rdl.value( '../DobbeltForskrivningsvarsel[1]', 'VARCHAR(1024)' ) AS DobbeltForskrivningsvarsel,
      rdl.value( 'Forskrivning[1]/Bruksomrade[1]', 'VARCHAR(1024)' ) AS Bruksomrade,
      rdl.value( 'Forskrivning[1]/DosVeiledEnkel[1]', 'VARCHAR(1024)' ) AS DosVeiledEnkel,
      rdl.value( 'Forskrivning[1]/Kortdose[1]/@DN', 'VARCHAR(1024)' ) AS Kortdose,
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
    RETURN;
END;
GO