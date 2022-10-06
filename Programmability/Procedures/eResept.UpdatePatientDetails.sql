SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [eResept].[UpdatePatientDetails]( @NationalId VARCHAR(16), @FmPatientId VARCHAR(50), @FstName VARCHAR(30), @LstName VARCHAR(30), @StreetAddress VARCHAR(64), @PostalCode VARCHAR(12), @City VARCHAR(32) ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.Person SET 
    FmPatientId =  @FmPatientId,
    StreetAddress = COALESCE( NULLIF( StreetAddress,'' ), @StreetAddress ), 
    PostalCode = COALESCE( NULLIF( PostalCode,'' ), @PostalCode ), 
    City = COALESCE( NULLIF( City, '' ), @City )
  WHERE NationalId = @NationalId;
END
GO

GRANT EXECUTE ON [eResept].[UpdatePatientDetails] TO [FastTrak]
GO