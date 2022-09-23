SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [FormEvents].[DeactivateStudyCaseIfAllSigned]( @ClinFormId INT ) AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @PersonId INT;
  DECLARE @StudyId INT;
  DECLARE @SignedBy INT;
  DECLARE @UnsignedCount INT;

  -- Find PersonId

  SELECT @PersonId = ce.PersonId, @StudyId = ce.StudyId
    FROM dbo.ClinEvent ce
    JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId
  WHERE cf.ClinFormId = @ClinFormId;

  -- Count unsigned for person and study
  
  SELECT @UnsignedCount = COUNT(*)
    FROM dbo.ClinForm cf
    JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId AND ce.StudyId = @StudyId
  WHERE ( ( cf.SignedAt IS NULL ) OR ( cf.FormCompleteRequired BETWEEN 0 AND 99 ) )
    AND cf.DeletedAt IS NULL
    AND ce.PersonId = @PersonId;
                                        
-- Set status to "Avsluttet" if there are no usigned forms

  IF @UnsignedCount = 0
  BEGIN
    DECLARE @StatusId INT;
    SELECT @StatusId = ss.StatusId 
    FROM dbo.StudyStatus ss WHERE ss.StatusText = 'Avsluttet';
    EXEC dbo.UpdateCaseStatus @StudyId, @PersonId, @StatusId;
  END;  
  
END
GO

GRANT EXECUTE ON [FormEvents].[DeactivateStudyCaseIfAllSigned] TO [FastTrak]
GO