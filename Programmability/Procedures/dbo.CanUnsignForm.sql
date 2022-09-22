SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CanUnsignForm]( @ClinFormId INT, @CanUnsign INT OUTPUT, @MessageText VARCHAR(MAX) OUTPUT ) 
AS
BEGIN
  SET @CanUnsign = 0;
  IF ( IS_MEMBER('Superuser') + IS_MEMBER('Journalansvarlig') ) > 0
  BEGIN
    SET @MessageText = 'Superbruker og Journalansvarlig kan gjenåpne andres skjema.';
    SET @CanUnsign = 2;
    RETURN;
  END
  ELSE
  BEGIN                            
    DECLARE @SignedBy INT;
    SELECT @SignedBy = SignedBy FROM dbo.ClinForm WHERE ClinFormId=@ClinFormId;
    IF ( @SignedBy IS NULL )
    BEGIN
      SET @MessageText = 'Skjemaet er usignert!';
      RETURN;
    END  
    ELSE IF ( @SignedBy=USER_ID() )
    BEGIN 
      SET @MessageText = 'Brukere kan gjenåpne sine egne skjema.';
      SET @CanUnsign = 1;
    END
    ELSE  
    BEGIN
      SET @MessageText = 'Skjemaet er signert av en annen bruker: ';
      SET @MessageText = @MessageText + ISNULL(USER_NAME(@SignedBy),'(ukjent)') + '.\n';
      SET @MessageText = @MessageText + 'Denne brukeren, Superbruker eller Journalansvarlig kan gjenåpne skjemaet!';             
      SET @CanUnsign = -1;
    END;
  END;
END
GO

GRANT EXECUTE ON [dbo].[CanUnsignForm] TO [FastTrak]
GO