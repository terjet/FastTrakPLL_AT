SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetAndRemoveStudyCasesWithoutForms]( @StudyId INT ) AS
BEGIN
  SELECT sc.StudCaseId, sc.PersonId, COUNT( EventId ) AS Antall
  INTO #temp
  FROM dbo.StudCase sc 
  LEFT JOIN dbo.ClinEvent ce ON sc.StudyId = ce.StudyId AND sc.PersonId = ce.PersonId
  WHERE sc.StudyId = @StudyId
  GROUP BY sc.StudCaseId, sc.PersonId
  HAVING COUNT( EventId ) = 0;
  DELETE FROM dbo.StudCaseLog WHERE StudCaseId IN ( SELECT StudCaseId FROM #temp );
  DELETE FROM dbo.StudCase WHERE StudCaseId IN ( SELECT StudCaseId FROM #temp );
  -- Return the list of removed patients.
  SELECT p.PersonId, p.DOB, p.FullName, 'Slettet' AS GroupName, 
    'Hadde ingen skjema' AS InfoText
  FROM #temp t 
  JOIN dbo.Person p ON p.PersonId = t.PersonId;
END
GO

GRANT EXECUTE ON [dbo].[GetAndRemoveStudyCasesWithoutForms] TO [Administrator]
GO