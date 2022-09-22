SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[GetPatientDetails] @PersonId INT AS
BEGIN
  SELECT 
    p.FMPatientId, p.DOB, p.FstName, p.MidName, p.LstName, p.GenderId, p.NationalId, 
   'X' AS AddressType, p.StreetAddress, p.PostalCode, p.City, 
    p.FMEnabled
  FROM dbo.Person p
  WHERE p.PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [eResept].[GetPatientDetails] TO [FastTrak]
GO