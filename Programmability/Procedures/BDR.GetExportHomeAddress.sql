SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetExportHomeAddress] AS
BEGIN
  SELECT p.NationalId, p.StreetAddress, p.City, p.PostalCode 
  FROM dbo.Person p 
  JOIN dbo.StudyCase sc ON sc.PersonId = p.PersonId 
  JOIN dbo.Study s ON s.StudyId = sc.StudyId 
  WHERE s.StudyName = 'BARNEDIABETES';
END
GO

GRANT EXECUTE ON [BDR].[GetExportHomeAddress] TO [Administrator]
GO