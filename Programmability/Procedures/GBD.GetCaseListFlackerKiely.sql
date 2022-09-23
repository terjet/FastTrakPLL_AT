SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListFlackerKiely]( @StudyId INT ) AS 
BEGIN
  -- Using StatusText AS GroupName on purpose
  SELECT v.PersonId, v.DOB, v.FullName, v.StudyId, ss.StatusText AS GroupName, v.GenderId,
      'Utfylt: ' + CONVERT(VARCHAR,forms.LastFormDate,104) AS InfoText 
    FROM dbo.ViewActiveCaseListStub v
    JOIN
    (
      SELECT ce.PersonId, MAX(ce.EventTime) AS LastFormDate
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId
      JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId AND mf.FormName='FLACKER_KIELY'
      GROUP BY ce.PersonId 
    ) forms ON forms.PersonId = v.PersonId
  JOIN dbo.StudCase sc ON sc.StudyId = v.StudyId AND sc.PersonId = v.PersonId
  JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = sc.StatusId  
  WHERE v.StudyId = @StudyId
  ORDER BY forms.LastFormDate;
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListFlackerKiely] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFlackerKiely] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFlackerKiely] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListFlackerKiely] TO [Vernepleier]
GO