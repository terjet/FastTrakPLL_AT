SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[UpdateCommDetails]( @ContactGuid uniqueidentifier, @GSM VARCHAR(20), @EmailAddress VARCHAR(64), @BostedKommune VARCHAR(64), @TrackingResponsible VARCHAR(64) ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @EmployeeNumber INT;
  DECLARE @PersonId INT;
  -- Retrieve existing email/phone number
  SELECT @PersonId = p.PersonId, @EmployeeNumber = p.EmployeeNumber
  FROM dbo.Person p JOIN Pandemic.Contact c on c.ContactPersonId = p.PersonId AND c.ContactGuid = @ContactGuid;
  -- Update contact data locally
  UPDATE Pandemic.Contact 
    SET GSM = @GSM, EmailAddress = @EmailAddress, BostedKommune = @BostedKommune,
      TrackingResponsible = @TrackingResponsible
  WHERE ContactGuid = @ContactGuid;
  -- Write to person table unless this is an employee
  IF ( @EmployeeNumber IS NULL ) AND ( @PersonId > 0 )
  BEGIN
	UPDATE dbo.Person SET EmailAddress = @EmailAddress WHERE PersonId = @PersonId;
    UPDATE dbo.Person SET GSM = @GSM WHERE PersonId = @PersonId;
  END;
END
GO