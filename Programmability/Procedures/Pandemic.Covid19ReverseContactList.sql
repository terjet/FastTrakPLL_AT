SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[Covid19ReverseContactList]( @PersonId INT ) AS
BEGIN
  SELECT 
    p.PersonId, p.ReverseName, p.JobTitle, p.WorkDepartment, p.EmailAddress, p.GSM, pcr.MuniName,
    PhoneItem.TextVal AS PhoneNumberItem 
  FROM Pandemic.AllContacts c
  JOIN dbo.Person p ON p.PersonId = c.IndexPersonId
  LEFT JOIN dbo.PostalCodeRegister pcr ON pcr.PostalCode = p.PostalCode
  LEFT JOIN dbo.GetLastTextValuesTable( 2244, NULL) PhoneItem ON PhoneItem.PersonId = p.PersonId
  WHERE c.ContactPersonId = @PersonId AND c.ContextId = 1
  ORDER BY p.ReverseName;
END
GO

GRANT EXECUTE ON [Pandemic].[Covid19ReverseContactList] TO [Pandemic]
GO