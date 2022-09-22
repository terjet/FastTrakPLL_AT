SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[UpdateClinFormArchiveStatus]( @ClinFormId INT, @ArchiveStatus BIT ) AS
BEGIN
  -- Check if the form is to be signed. If so user has to be Journalansvarlig or the signer of the form.
  -- Also, the form must be signed to allow archiving
  IF (@ArchiveStatus = 1)
  BEGIN
    DECLARE @SignedBy INT;
    DECLARE @IsJournalAnsvarlig INT;
    SET @IsJournalAnsvarlig = 0;

    SELECT @SignedBy = SignedBy
      FROM dbo.ClinForm
     WHERE ClinFormId = @ClinFormId;
     
    IF (@SignedBy IS NULL)
    BEGIN
      RAISERROR( 'Kun signerte skjema kan arkiveres!', 16, 1 );
      RETURN -1;
    END;
    
    SELECT @IsJournalAnsvarlig = 1  
      FROM dbo.ClinForm cf
           JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
           JOIN dbo.StudCase sc ON sc.StudyId = ce.StudyId AND sc.PersonId = ce.PersonId
     WHERE cf.ClinFormId = @ClinFormId
       AND sc.Journalansvarlig = USER_ID();

    IF ((@IsJournalAnsvarlig = 0) AND (@SignedBy <> USER_ID()))
    BEGIN
      RAISERROR( 'Du må være journalansvarlig for pasienten i denne fagjournalen eller ha signert skjemaet for å kunne arkivere det!', 16, 1 );
      RETURN -2;
    END;
  END;
  
  UPDATE dbo.ClinForm SET Archived = @ArchiveStatus 
  WHERE ( ClinFormId = @ClinFormId ) AND ( Archived <> @ArchiveStatus );
END
GO

GRANT EXECUTE ON [CRF].[UpdateClinFormArchiveStatus] TO [Journalansvarlig]
GO

GRANT EXECUTE ON [CRF].[UpdateClinFormArchiveStatus] TO [superuser]
GO