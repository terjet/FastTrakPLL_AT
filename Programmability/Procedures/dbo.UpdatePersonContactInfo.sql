SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdatePersonContactInfo] ( @NationalId VARCHAR(16), @GSM VARCHAR(16), @StreetAddress VARCHAR(64), @PostalCode VARCHAR(12), @City VARCHAR(32), @KommuneNr VARCHAR(8), @KommuneNavn VARCHAR(32) ) AS
BEGIN
  UPDATE dbo.Person
  SET StreetAddress = @StreetAddress, PostalCode = @PostalCode, City = @City, KommuneNr = @KommuneNr, KommuneNavn = @KommuneNavn
  WHERE NationalId = @NationalId;
  IF @GSM <> ''
    UPDATE dbo.Person
    SET GSM = @GSM
    WHERE GSM <> @GSM
    AND NationalId = @NationalId
END
GO