SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Test].[AddTestAddresses] AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.Person 
   SET 
     StreetAddress = CONCAT(FstName + 'gata ', PersonId ),
     PostalCode = CONCAT('X4', PersonId ), City = UPPER(CONCAT(LstName,'BY' ))
    WHERE PostalCode IS NULL;
END;
GO