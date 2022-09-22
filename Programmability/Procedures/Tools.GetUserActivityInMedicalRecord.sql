SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[GetUserActivityInMedicalRecord] ( @StudyId INT, @UserId INT, @PersonId INT ) AS
BEGIN
  SELECT CreatedAt AS Tidspunkt, PersonId, 'CaseLog' AS Logg,  
    cl.LogId AS clLogId, LogText, LogType, -- CaseLog
    NULL AS pdlLogId, NULL AS DocumentId, NULL AS Content, -- PersonDocumentLog
    NULL AS ClinFormId, NULL AS Comment, NULL AS ClinFormLogId, NULL AS FormStatus, NULL AS FormComplete, NULL AS cflSignedAt, NULL AS cflSignedBy, --ClinFormLog
    NULL AS cdplLogId, NULL AS RowId, NULL AS TouchId, NULL AS ObsDate, NULL AS Quantity, NULL AS DTVal, NULL AS EnumVal, NULL AS TextVal,
    NULL AS StudCaseLogId, NULL AS StudCaseId, NULL AS NewStatusId, NULL AS OldStatusId, NULL AS NewGroupId, NULL AS OldGroupId, NULL AS OldHandler, -- StudCaseLog
    NULL AS NewHandler, NULL AS OldJournalAnsvarlig, NULL AS NewJournalAnsvarlig,
    NULL AS plLogId, NULL AS DOB, NULL AS FstName, NULL AS LstName, NULL AS GenderId, NULL AS NationalId, NULL AS guid, NULL AS TestCase, NULL AS MidName, -- PersonLog
    NULL AS DeceasedDate, NULL AS DeceasedInd,
    NULL AS TreatId, NULL AS ATC, NULL AS ATCVersion, NULL AS DrugName, NULL AS DrugForm, NULL AS TreatType, NULL AS PackType, NULL AS TreatPackType, -- DrugTreatment
    NULL AS Strength, NULL AS StrengthUnit, NULL AS Dose24hCount, NULL AS Dose24hDD, NULL AS StartAt, NULL AS StartFuzzy,
    NULL AS StartReason, NULL AS RxText, NULL AS StopAt, NULL AS StopFuzzy, NULL AS StopReason, NULL AS DoseCode, NULL AS PauseStatus,
    NULL AS CreatedAt, NULL AS DoseId, NULL AS StartedBy, NULL AS CreatedBy, NULL AS StopBy, NULL AS BatchId,
    NULL AS dtSignedBy, NULL AS dtSignedAt, NULL AS StopAuthorizedByName, NULL AS dtClinFormId
    FROM dbo.CaseLog cl
  WHERE CreatedBy = @UserId AND cl.PersonId = @PersonId
  UNION ALL
  SELECT ChangedAt, PersonId, 'PersonDocumentLog' AS Logg,
    NULL AS clLogId, NULL AS LogText, NULL AS LogType,
    pdl.LogId AS pdlLogId, pdl.DocumentId, pdl.Content,
    NULL AS ClinFormId, NULL AS Comment, NULL AS ClinFormLogId, NULL AS FormStatus, NULL AS FormComplete, NULL AS cflSignedAt, NULL AS cflSignedBy,
    NULL AS cdplLogId, NULL AS RowId, NULL AS TouchId, NULL AS ObsDate, NULL AS Quantity, NULL AS DTVal, NULL AS EnumVal, NULL AS TextVal,
    NULL AS StudCaseLogId, NULL AS StudCaseId, NULL AS NewStatusId, NULL AS OldStatusId, NULL AS NewGroupId, NULL AS OldGroupId, NULL AS OldHandler,
    NULL AS NewHandler, NULL AS OldJournalAnsvarlig, NULL AS NewJournalAnsvarlig,
    NULL AS plLogId, NULL AS DOB, NULL AS FstName, NULL AS LstName, NULL AS GenderId, NULL AS NationalId, NULL AS guid, NULL AS TestCase, NULL AS MidName,
    NULL AS DeceasedDate, NULL AS DeceasedInd,
    NULL AS TreatId, NULL AS ATC, NULL AS ATCVersion, NULL AS DrugName, NULL AS DrugForm, NULL AS TreatType, NULL AS PackType, NULL AS TreatPackType,
    NULL AS Strength, NULL AS StrengthUnit, NULL AS Dose24hCount, NULL AS Dose24hDD, NULL AS StartAt, NULL AS StartFuzzy,
    NULL AS StartReason, NULL AS RxText, NULL AS StopAt, NULL AS StopFuzzy, NULL AS StopReason, NULL AS DoseCode, NULL AS PauseStatus,
    NULL AS CreatedAt, NULL AS DoseId, NULL AS StartedBy, NULL AS CreatedBy, NULL AS StopBy, NULL AS BatchId,
    NULL AS dtSignedBy, NULL AS dtSignedAt, NULL AS StopAuthorizedByName, NULL AS dtClinFormId
  FROM dbo.PersonDocumentLog pdl
  WHERE ChangedBy = @UserId AND pdl.PersonId = @PersonId
  UNION ALL
  SELECT cfl.CreatedAt, ce.PersonId, 'ClinFormLog' AS Logg,
    NULL AS clLogId, NULL AS LogText, NULL AS LogType,
    NULL AS pdlLogId, NULL AS DocumentId, NULL AS Content,
    cfl.ClinFormId, cfl.Comment, cfl.ClinFormLogId, cfl.FormStatus, cfl.FormComplete, cfl.SignedAt AS cflSignedAt, cfl.SignedBy,
    NULL AS cdplLogId, NULL AS RowId, NULL AS TouchId, NULL AS ObsDate, NULL AS Quantity, NULL AS DTVal, NULL AS EnumVal, NULL AS TextVal,
    NULL AS StudCaseLogId, NULL AS StudCaseId, NULL AS NewStatusId, NULL AS OldStatusId, NULL AS NewGroupId, NULL AS OldGroupId, NULL AS OldHandler,
    NULL AS NewHandler, NULL AS OldJournalAnsvarlig, NULL AS NewJournalAnsvarlig,
    NULL AS plLogId, NULL AS DOB, NULL AS FstName, NULL AS LstName, NULL AS GenderId, NULL AS NationalId, NULL AS guid, NULL AS TestCase, NULL AS MidName,
    NULL AS DeceasedDate, NULL AS DeceasedInd,
    NULL AS TreatId, NULL AS ATC, NULL AS ATCVersion, NULL AS DrugName, NULL AS DrugForm, NULL AS TreatType, NULL AS PackType, NULL AS TreatPackType,
    NULL AS Strength, NULL AS StrengthUnit, NULL AS Dose24hCount, NULL AS Dose24hDD, NULL AS StartAt, NULL AS StartFuzzy,
    NULL AS StartReason, NULL AS RxText, NULL AS StopAt, NULL AS StopFuzzy, NULL AS StopReason, NULL AS DoseCode, NULL AS PauseStatus,
    NULL AS CreatedAt, NULL AS DoseId, NULL AS StartedBy, NULL AS CreatedBy, NULL AS StopBy, NULL AS BatchId,
    NULL AS dtSignedBy, NULL AS dtSignedAt, NULL AS StopAuthorizedByName, NULL AS dtClinFormId
    FROM dbo.ClinFormLog cfl
  JOIN dbo.ClinForm cf ON cf.ClinFormId = cfl.ClinFormId
  JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
  WHERE cfl.CreatedBy = @UserId AND ce.PersonId = @PersonId
  UNION ALL
  SELECT cdpl.ChangedAt, ce.PersonId, 'ClinDataPointLog' AS Logg,
    NULL AS clLogId, NULL AS LogText, NULL AS LogType,
    NULL AS pdlLogId, NULL AS DocumentId, NULL AS Content,
    NULL AS ClinFormId, NULL AS Comment, NULL AS ClinFormLogId, NULL AS FormStatus, NULL AS FormComplete, NULL AS cflSignedAt, NULL AS cflSignedBy,
    cdpl.LogId AS cdplLogId, cdpl.RowId, cdpl.TouchId, cdpl.ObsDate, cdpl.Quantity, cdpl.DTVal, cdpl.EnumVal, cdpl.TextVal,
    NULL AS StudCaseLogId, NULL AS StudCaseId, NULL AS NewStatusId, NULL AS OldStatusId, NULL AS NewGroupId, NULL AS OldGroupId, NULL AS OldHandler,
    NULL AS NewHandler, NULL AS OldJournalAnsvarlig, NULL AS NewJournalAnsvarlig,
    NULL AS plLogId, NULL AS DOB, NULL AS FstName, NULL AS LstName, NULL AS GenderId, NULL AS NationalId, NULL AS guid, NULL AS TestCase, NULL AS MidName,
    NULL AS DeceasedDate, NULL AS DeceasedInd,
    NULL AS TreatId, NULL AS ATC, NULL AS ATCVersion, NULL AS DrugName, NULL AS DrugForm, NULL AS TreatType, NULL AS PackType, NULL AS TreatPackType,
    NULL AS Strength, NULL AS StrengthUnit, NULL AS Dose24hCount, NULL AS Dose24hDD, NULL AS StartAt, NULL AS StartFuzzy,
    NULL AS StartReason, NULL AS RxText, NULL AS StopAt, NULL AS StopFuzzy, NULL AS StopReason, NULL AS DoseCode, NULL AS PauseStatus,
    NULL AS CreatedAt, NULL AS DoseId, NULL AS StartedBy, NULL AS CreatedBy, NULL AS StopBy, NULL AS BatchId,
    NULL AS dtSignedBy, NULL AS dtSignedAt, NULL AS StopAuthorizedByName, NULL AS dtClinFormId
    FROM dbo.ClinDataPointLog cdpl
  JOIN dbo.ClinDataPoint cdp ON cdp.RowId = cdpl.RowId
  JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
  WHERE cdpl.ChangedBy = @UserId AND ce.PersonId = @PersonId
  UNION ALL
  SELECT scl.ChangedAt, sc.PersonId, 'StudCaseLog' AS Logg,
    NULL AS clLogId, NULL AS LogText, NULL AS LogType,
    NULL AS pdlLogId, NULL AS DocumentId, NULL AS Content,
    NULL AS ClinFormId, NULL AS Comment, NULL AS ClinFormLogId, NULL AS FormStatus, NULL AS FormComplete, NULL AS cflSignedAt, NULL AS cflSignedBy,
    NULL AS cdplLogId, NULL AS RowId, NULL AS TouchId, NULL AS ObsDate, NULL AS Quantity, NULL AS DTVal, NULL AS EnumVal, NULL AS TextVal,
    scl.StudCaseLogId, scl.StudCaseId, scl.NewStatusId, scl.OldStatusId, scl.NewGroupId, scl.OldGroupId, scl.OldHandler, scl.NewHandler, scl.OldJournalAnsvarlig, scl.NewJournalAnsvarlig,
    NULL AS plLogId, NULL AS DOB, NULL AS FstName, NULL AS LstName, NULL AS GenderId, NULL AS NationalId, NULL AS guid, NULL AS TestCase, NULL AS MidName,
    NULL AS DeceasedDate, NULL AS DeceasedInd,
    NULL AS TreatId, NULL AS ATC, NULL AS ATCVersion, NULL AS DrugName, NULL AS DrugForm, NULL AS TreatType, NULL AS PackType, NULL AS TreatPackType,
    NULL AS Strength, NULL AS StrengthUnit, NULL AS Dose24hCount, NULL AS Dose24hDD, NULL AS StartAt, NULL AS StartFuzzy,
    NULL AS StartReason, NULL AS RxText, NULL AS StopAt, NULL AS StopFuzzy, NULL AS StopReason, NULL AS DoseCode, NULL AS PauseStatus,
    NULL AS CreatedAt, NULL AS DoseId, NULL AS StartedBy, NULL AS CreatedBy, NULL AS StopBy, NULL AS BatchId,
    NULL AS dtSignedBy, NULL AS dtSignedAt, NULL AS StopAuthorizedByName, NULL AS dtClinFormId
    FROM dbo.StudCaseLog scl
    JOIN dbo.StudCase sc ON sc.StudCaseId = scl.StudCaseId
  WHERE scl.ChangedBy = @UserId AND sc.StudyId = @StudyId AND sc.PersonId = @PersonId
  UNION ALL
  SELECT ChangedAt, PersonId, 'PersonLog' AS Logg,
    NULL AS clLogId, NULL AS LogText, NULL AS LogType,
    NULL AS pdlLogId, NULL AS DocumentId, NULL AS Content,
    NULL AS ClinFormId, NULL AS Comment, NULL AS ClinFormLogId, NULL AS FormStatus, NULL AS FormComplete, NULL AS cflSignedAt, NULL AS cflSignedBy,
    NULL AS cdplLogId, NULL AS RowId, NULL AS TouchId, NULL AS ObsDate, NULL AS Quantity, NULL AS DTVal, NULL AS EnumVal, NULL AS TextVal,
    NULL AS StudCaseLogId, NULL AS StudCaseId, NULL AS NewStatusId, NULL AS OldStatusId, NULL AS NewGroupId, NULL AS OldGroupId, NULL AS OldHandler,
    NULL AS NewHandler, NULL AS OldJournalAnsvarlig, NULL AS NewJournalAnsvarlig,
    pl.LogId AS plLogId, pl.DOB, pl.FstName, pl.LstName, pl.GenderId, pl.NationalId, pl.guid, pl.TestCase, pl.MidName, pl.DeceasedDate, pl.DeceasedInd,
    NULL AS TreatId, NULL AS ATC, NULL AS ATCVersion, NULL AS DrugName, NULL AS DrugForm, NULL AS TreatType, NULL AS PackType, NULL AS TreatPackType,
    NULL AS Strength, NULL AS StrengthUnit, NULL AS Dose24hCount, NULL AS Dose24hDD, NULL AS StartAt, NULL AS StartFuzzy,
    NULL AS StartReason, NULL AS RxText, NULL AS StopAt, NULL AS StopFuzzy, NULL AS StopReason, NULL AS DoseCode, NULL AS PauseStatus,
    NULL AS CreatedAt, NULL AS DoseId, NULL AS StartedBy, NULL AS CreatedBy, NULL AS StopBy, NULL AS BatchId,
    NULL AS dtSignedBy, NULL AS dtSignedAt, NULL AS StopAuthorizedByName, NULL AS dtClinFormId
    FROM dbo.PersonLog pl
  WHERE ChangedBy = @UserId AND pl.PersonId = @PersonId
  UNION ALL
  SELECT CASE 
      WHEN dt.CreatedBy = @UserId THEN dt.CreatedAt
      WHEN dt.StartedBy = @UserId THEN dt.StartAt
      WHEN dt.SignedBy = @UserId THEN dt.SignedAt
      WHEN dt.StopBy = @UserId THEN dt.StopAt
    END AS DateOfAction,
    dt.PersonId, 'DrugTreatment' AS Logg,
    NULL AS clLogId, NULL AS LogText, NULL AS LogType,
    NULL AS pdlLogId, NULL AS DocumentId, NULL AS Content,
    NULL AS ClinFormId, NULL AS Comment, NULL AS ClinFormLogId, NULL AS FormStatus, NULL AS FormComplete, NULL AS cflSignedAt, NULL AS cflSignedBy,
    NULL AS cdplLogId, NULL AS RowId, NULL AS TouchId, NULL AS ObsDate, NULL AS Quantity, NULL AS DTVal, NULL AS EnumVal, NULL AS TextVal,
    NULL AS StudCaseLogId, NULL AS StudCaseId, NULL AS NewStatusId, NULL AS OldStatusId, NULL AS NewGroupId, NULL AS OldGroupId, NULL AS OldHandler,
    NULL AS NewHandler, NULL AS OldJournalAnsvarlig, NULL AS NewJournalAnsvarlig,
    NULL AS plLogId, NULL AS DOB, NULL AS FstName, NULL AS LstName, NULL AS GenderId, NULL AS NationalId, NULL AS guid, NULL AS TestCase, NULL AS MidName,
    NULL AS DeceasedDate, NULL AS DeceasedInd,
    dt.TreatId, dt.ATC, dt.ATCVersion, dt.DrugName, dt.DrugForm, dt.TreatType, dt.PackType, dt.TreatPackType, dt.Strength, dt.StrengthUnit, dt.Dose24hCount, dt.Dose24hDD, dt.StartAt, dt.StartFuzzy,
    dt.StartReason, dt.RxText, dt.StopAt, dt.StopFuzzy, dt.StopReason, dt.DoseCode, dt.PauseStatus, dt.CreatedAt, dt.DoseId, dt.StartedBy, dt.CreatedBy, dt.StopBy, dt.BatchId,
    dt.SignedBy AS dtSignedBy, dt.SignedAt, dt.StopAuthorizedByName, dt.ClinFormId
    FROM dbo.DrugTreatment dt
  WHERE @UserId IN (dt.CreatedBy, StartedBy, SignedBy, StopBy) AND dt.PersonId = @PersonId
  ORDER BY Tidspunkt
END;
GO