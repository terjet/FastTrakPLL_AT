SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListFlackerKielyPending]( @StudyId INT ) AS 
BEGIN
  DECLARE @IgnoreFormsAfter DateTime;
  SET @IgnoreFormsAfter = GETDATE() - 180;
  -- Using StatusText AS GroupName on purpose
  SELECT v.PersonId, v.DOB, v.FullName, v.StudyId, ss.StatusText AS GroupName, v.GenderId,
      'Utfylt: ' + ISNULL(CONVERT(VARCHAR,forms.LastFormDate,104), 'Aldri') AS InfoText 
    FROM dbo.ViewActiveCaseListStub v
    LEFT JOIN
    (
      SELECT ce.PersonId, MAX(ce.EventTime) AS LastFormDate
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId
      JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId AND mf.FormName='FLACKER_KIELY'
      GROUP BY ce.PersonId 
    ) forms ON forms.PersonId = v.PersonId
  JOIN dbo.StudCase sc ON sc.StudyId = v.StudyId AND sc.PersonId = v.PersonId
  JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = sc.StatusId  
  WHERE v.StudyId = @StudyId AND ( ( forms.LastFormDate <= @IgnoreFormsAfter ) OR ( forms.LastFormDate IS NULL ) )
  ORDER BY forms.LastFormDate;
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListFlackerKielyPending] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFlackerKielyPending] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFlackerKielyPending] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFlackerKielyPending] TO [Vernepleier]
GO