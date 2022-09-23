SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[RuleAutoClose]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @DpAvsluttet INT;           
  SELECT TOP 1 @DpAvsluttet = EnumVal 
    FROM dbo.ClinDataPoint cdp 
    JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId 
    WHERE ce.PersonId = @PersonId AND cdp.ItemId = 7746
    AND cdp.ObsDate > GETDATE()-1
    ORDER BY ce.EventNum DESC;
  IF @DpAvsluttet = 1
  BEGIN                                   
    -- Set to "Avsluttet" and remove from group.
    UPDATE dbo.StudCase SET FinState = 4, GroupId = NULL 
    WHERE StudyId = @StudyId AND PersonId = @PersonId;
    EXEC dbo.AddAlertForPerson @StudyId,@PersonId,1,'NDVAVSLUTT','Include','Avsluttet','Avsluttet på diabetespoliklinikken basert på informasjon fra skjema..';
  END
  ELSE      
    EXEC dbo.AddAlertForPerson @StudyId,@PersonId,0,'NDVAVSLUTT','Exclude','Fortsetter','Ikke avsluttet på diabetespoliklinikken, basert på informasjon fra skjema.';
END
GO

GRANT EXECUTE ON [NDV].[RuleAutoClose] TO [FastTrak]
GO