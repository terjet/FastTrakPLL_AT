SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[AddPostalCode]( @Country INT, @PostalCode VARCHAR(12), @City VARCHAR(32), @MuniCode VARCHAR(4), @MuniName VARCHAR(32), @CodeType VARCHAR(1) ) AS
BEGIN
  SET NOCOUNT ON; 
  UPDATE dbo.PostalCodeRegister SET City = @City, MuniCode = @MuniCode, MuniName = @MuniName, CodeType = @CodeType
    WHERE Country = @Country AND PostalCode = @PostalCode;
  IF @@ROWCOUNT = 0
    INSERT INTO dbo.PostalCodeRegister ( Country, PostalCode, City,  MuniCode, MuniName, CodeType )
  VALUES ( @Country, @PostalCode, @City,  @MuniCode, @MuniName, @CodeType );
END
GO