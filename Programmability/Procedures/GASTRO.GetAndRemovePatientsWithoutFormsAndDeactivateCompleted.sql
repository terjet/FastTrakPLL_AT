SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GASTRO].[GetAndRemovePatientsWithoutFormsAndDeactivateCompleted] (@StudyId INT) AS
BEGIN
  -- Fjern pasientar utan skjema frå protokollen
  SELECT sc.StudCaseId, sc.PersonId, COUNT(EventId) AS Antall INTO #Slett
  FROM dbo.StudCase sc
  LEFT JOIN dbo.ClinEvent ce ON sc.StudyId = ce.StudyId AND sc.PersonId = ce.PersonId
  WHERE sc.StudyId = @StudyId
  GROUP BY sc.StudCaseId,
           sc.PersonId
  HAVING COUNT(EventId) = 0;
  DELETE FROM dbo.StudCaseLog
  WHERE StudCaseId IN (SELECT StudCaseId
      FROM #Slett);
  DELETE FROM dbo.StudCase
  WHERE StudCaseId IN (SELECT StudCaseId
      FROM #Slett);

  -- Deaktiver fullførte pasientar 
  SELECT v.PersonId INTO #Deaktiver
  FROM dbo.ViewActiveCaseListStub v
  WHERE NOT EXISTS (SELECT v1.PersonId
    FROM dbo.ViewActiveCaseListStub v1
    JOIN dbo.ClinEvent ce
      ON ce.PersonId = v1.PersonId AND ce.StudyId = @StudyId
    JOIN dbo.ClinForm cf
      ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
    JOIN dbo.MetaForm mf
      ON mf.FormId = cf.FormId
    WHERE v1.StudyId = @StudyId
    AND v.PersonId = v1.PersonId
    AND (cf.SignedAt IS NULL
    OR (mf.FormName = 'SCREENINGKOLOSKOPI'
    AND ISNULL(cf.FormCompleteRequired, 0) < 100)))
  AND v.StudyId = @StudyId

  UPDATE sc
  SET GroupId = NULL,
  FinState = 4
  FROM dbo.StudCase sc
  JOIN #Deaktiver d
    ON d.PersonId = sc.PersonId

  -- Returner lista over sletta og deaktiverte pasientar
  SELECT p.PersonId, p.DOB, p.FullName, 'Fjernet' AS GroupName,
    'Hadde ingen skjema' AS InfoText
  FROM #Slett t
  JOIN dbo.Person p ON p.PersonId = t.PersonId

  UNION ALL

  SELECT p.PersonId, p.DOB, p.FullName, 'Deaktivert' AS GroupName,
    'Fullført pasient' AS InfoText
  FROM #Deaktiver d
  JOIN dbo.Person p ON p.PersonId = d.PersonId;
END
GO

GRANT EXECUTE ON [GASTRO].[GetAndRemovePatientsWithoutFormsAndDeactivateCompleted] TO [superuser]
GO

GRANT EXECUTE ON [GASTRO].[GetAndRemovePatientsWithoutFormsAndDeactivateCompleted] TO [Systemansvarlig]
GO