SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdatePersonSetNationalId]( @PersonId INT, @NationalId VARCHAR(16) )
AS
  DECLARE @ExistingPersonId INT;
  DECLARE @MsgText varchar(255);
  DECLARE @FullName varchar(255);
BEGIN
  IF DATALENGTH( @NationalId )<11 SET @NationalId = NULL;
  IF NOT @NationalId IS NULL
  BEGIN
    SELECT @ExistingPersonId = MAX(PersonId) FROM dbo.Person WHERE NationalId = @NationalId AND PersonId <> @PersonId;
    IF NOT @ExistingPersonId IS NULL
    BEGIN
      SELECT @FullName= FullName FROM Person WHERE PersonId=@ExistingPersonId;
      SET @MsgText =
          'Det finnes en annen person med dette personnummeret!\n'+
          'Den andre personen har PID = %d (%s)\n'+
          'Hvis personen er dobbeltregistrert må du fjerne\n' +
          'personnummeret på den personen som ikke skal brukes!';
      RAISERROR( @MsgText, 16, 1, @ExistingPersonId, @FullName );
      RETURN -1;
    END;
  END
  UPDATE dbo.Person SET NationalId=@NationalId WHERE PersonId=@PersonId;
END
GO