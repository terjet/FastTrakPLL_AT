SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RapportBrukereMedKliniskeData] AS
BEGIN
  SELECT * FROM (
    SELECT ul.UserId, p.PersonId, p.DOB, p.ReverseName, 
      (SELECT COUNT(*) FROM dbo.ClinEvent ce WHERE ce.PersonId = ul.PersonId) ClinEventCount, 
      (SELECT COUNT(*) FROM dbo.LabData ld WHERE ld.PersonId = ul.PersonId) LabDataCount, 
      (SELECT COUNT(*) FROM dbo.DrugTreatment dt WHERE dt.PersonId = ul.PersonId) DrugTreatmentCount
    FROM dbo.UserList ul
    JOIN dbo.Person p ON ul.PersonId = p.PersonId) Patients
    WHERE ClinEventCount > 0 OR LabDataCount > 0 OR DrugTreatmentCount > 0
    ORDER BY ReverseName;
END
GO

GRANT EXECUTE ON [GBD].[RapportBrukereMedKliniskeData] TO [superuser]
GO