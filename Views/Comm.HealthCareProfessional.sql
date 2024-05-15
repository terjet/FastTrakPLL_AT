SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [Comm].[HealthCareProfessional] AS
  SELECT 
    mp.OID9060 AS TypeHealthCareProfessional,                               
    LstName AS FamilyName,
    '' AS MiddleName,
    FstName AS GivenName, 
    DOB AS DateOfBirth, GenderId AS Sex,
    '' AS Nationality,'' AS Address, GSM AS TeleCom
  FROM Person p
  JOIN UserList ul ON ul.PersonId=p.PersonId
  JOIN MetaProfession mp ON mp.ProfId=ul.ProfId 
  WHERE HPRNo > 0;
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [Comm].[HealthCareProfessional] TO [public]
GO