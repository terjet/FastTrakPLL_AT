SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdatePersonImportantInfo]( @PersonId INT, @DocId INT, @DocText VARCHAR(MAX) ) AS
BEGIN
  IF NOT dbo.GetMyProfession() IN ('LE','SP','FT','BI','VP','ET') 
  BEGIN
    RAISERROR( 'Bare høyskoleutdannet helsepersonell kan redigere denne informasjonen!', 16, 1 );
	RETURN -1;
  END;
  IF @DocId=50001 
    UPDATE dbo.Person SET CAVE=@DocText WHERE PersonId=@PersonId
  ELSE IF @DocId=50003 
    UPDATE dbo.Person SET Reservations=@DocText WHERE PersonId=@PersonId
  ELSE IF @DocId=50005 
    UPDATE dbo.Person SET NB=@DocText WHERE PersonId=@PersonId
  ELSE IF @DocId=11036
    UPDATE dbo.Person SET Allergies=@DocText WHERE PersonId=@PersonId
  ELSE
    RAISERROR( 'Ukjent dokumentidentifikator angitt.', 16, 1 );
END
GO

GRANT EXECUTE ON [dbo].[UpdatePersonImportantInfo] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdatePersonImportantInfo] TO [ReadOnly]
GO