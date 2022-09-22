SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateCaseTransfer]( @StudyId INT, @PersonId INT, @GroupId INT, @StatusId INT ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.StudCase SET GroupId = @GroupId, FinState = @StatusId, Journalansvarlig = NULL
  WHERE StudyId = @StudyId AND PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [dbo].[UpdateCaseTransfer] TO [Avdelingsleder]
GO

GRANT EXECUTE ON [dbo].[UpdateCaseTransfer] TO [FastTrak]
GO

GRANT EXECUTE ON [dbo].[UpdateCaseTransfer] TO [Gruppeleder]
GO

GRANT EXECUTE ON [dbo].[UpdateCaseTransfer] TO [Journalansvarlig]
GO

GRANT EXECUTE ON [dbo].[UpdateCaseTransfer] TO [Leder]
GO

DENY EXECUTE ON [dbo].[UpdateCaseTransfer] TO [ReadOnly]
GO