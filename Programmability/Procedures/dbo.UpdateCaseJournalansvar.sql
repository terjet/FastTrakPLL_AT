SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateCaseJournalansvar]( @StudyId INT, @PersonId INT )
AS
BEGIN
  UPDATE dbo.StudCase SET Journalansvarlig = USER_ID() WHERE StudyId=@StudyId AND PersonId=@PersonId
END
GO

GRANT EXECUTE ON [dbo].[UpdateCaseJournalansvar] TO [Journalansvarlig]
GO