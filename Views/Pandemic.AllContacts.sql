SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [Pandemic].[AllContacts] AS
  SELECT
    ISNULL(cp.DOB, c.DOB ) AS MergedDob,
    ISNULL(cp.GenderId, c.GenderId ) AS MergedGenderId,
    ISNULL(NULLIF(cp.FstName,''),c.FirstName) AS MergedFirstName,
    ISNULL(NULLIF(cp.LstName,''),c.LastName) AS MergedLastName,
    ISNULL(NULLIF(cp.GSM,''),c.GSM) AS MergedPhoneNumber,
    ISNULL(NULLIF(cp.EmailAddress,''),c.EmailAddress) AS MergedEmailAddress,
    ISNULL(NULLIF(c.BostedKommune,''), pcr.MuniName ) AS MergedBostedKommune,
    c.*,
	sup.FullName AS SuperFullName, sup.GSM AS SuperPhoneNumber,
    cp.PersonId, cp.ReverseName, cp.FullName, cp.NationalId, cp.KommuneNavn, cp.StreetAddress, cp.PostalCode, cp.City, 
	cp.WorkDepartment, cp.JobTitle,
	mcs.StateName,
	ISNULL(pu.UserName,ul.UserName) AS CaseTrackedByUserName
  FROM Pandemic.Contact c
  JOIN Pandemic.MetaContactState mcs ON mcs.StateId = c.StateId
  LEFT JOIN dbo.Person cp ON cp.PersonId = c.ContactPersonId
  LEFT JOIN dbo.UserList ul ON ul.UserId = c.CaseTrackedBy
  LEFT JOIN dbo.Person pu ON pu.PersonId = ul.PersonId
  LEFT JOIN dbo.Person sup ON sup.EmployeeNumber = cp.SupervisorEmployeeNumber
  LEFT JOIN dbo.PostalCodeRegister pcr ON pcr.PostalCode = cp.HomePostalCode 
  WHERE c.DeletedAt IS NULL;
GO