SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[ClinicalNews]( @StudyId INT, @StartAt DateTime, @StopAt DateTime ) AS
BEGIN
  SELECT 
    p.PersonId, p.DOB, p.FullName, mf.FormTitle, cf.Comment, cf.CachedText,
    dbo.ShortTime(ce.EventTime) AS ShortTime,
    ce.EventTime, up.FullName AS UserFullName, up.Signature, p.GroupName, 
    cf.CreatedAt
  FROM dbo.ViewActiveCaseListStub p
  JOIN dbo.ClinEvent ce ON ce.PersonId = p.PersonId AND ce.StudyId = p.StudyId
  JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND DeletedAt IS NULL 
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
  LEFT JOIN dbo.UserList ul ON ul.UserId = cf.CreatedBy
  LEFT JOIN dbo.Person up ON up.PersonId = ul.PersonId                                                                                                  
  WHERE p.StudyId = @StudyId AND
      ( ( ce.EventTime >= @StartAt AND ce.EventTime < @StopAt ) OR
      ( mf.FormName IN ('GBD_DRIKKE', 'Glukose24t', 'GBD_ATFERD') AND ce.EventTime >= CONVERT(DATE, @StartAt) AND ce.EventTime < @StopAt ) )
  ORDER BY p.GroupName, p.FullName, p.PersonId, ce.EventTime DESC;
END
GO

GRANT EXECUTE ON [report].[ClinicalNews] TO [FastTrak]
GO