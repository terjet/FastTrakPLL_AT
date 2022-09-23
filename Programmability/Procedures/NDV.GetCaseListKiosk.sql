SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListKiosk]( @StudyId INT ) AS
BEGIN   
  SELECT DISTINCT v.PersonId, v.DOB, v.FullName, p.GenderId,     
    CASE cf.Archived WHEN 1 THEN 'Kontroll' ELSE 'Intervensjon' END AS GroupName,     
    'Tid ' + dbo.ShortTime( ce.EventTime) + ', Kode: ' + kf.FormTag AS InfoText,      
    ce.EventTime, cf.ClinFormId   
  FROM PROM.KioskForm kf     
  JOIN dbo.ClinForm cf ON cf.ClinFormId = kf.ClinFormId AND cf.FormId = 906 AND cf.DeletedAt IS NULL
  JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId     
  JOIN dbo.ViewCaseListStub v ON v.PersonId = ce.PersonId      
  JOIN dbo.Person p ON p.PersonId = v.PersonId   
  WHERE v.StudyId = @StudyId 
  ORDER BY ce.EventTime DESC;
END;
GO

GRANT EXECUTE ON [NDV].[GetCaseListKiosk] TO [FastTrak]
GO