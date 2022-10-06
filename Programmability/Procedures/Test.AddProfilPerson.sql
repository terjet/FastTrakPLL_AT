SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Test].[AddProfilPerson]( @ProfilId INT, @NationalId VARCHAR(16), @DOB DATE, @GenderId INT ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @FstName VARCHAR(50) = CONCAT( 'Testperson ', @ProfilId );
  EXEC dbo.AddPerson @DOB, @FstName, NULL, 'Profil', @GenderId, @NationalId;
  UPDATE dbo.Person SET ExistsInProfil = 1, FstName = @FstName, MidName = NULL, LstName='Profil', FMPatientId = @ProfilId, TestCase = 1
  WHERE NationalId = @NationalId;
END;
GO