SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateCaseStatus]( @StudyId INT, @PersonId INT, @StatusId INT ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @StatusActive INT;
  EXEC dbo.AddStudCase @StudyId, @PersonId;
  SELECT @StatusActive = StatusActive FROM dbo.StudyStatus WHERE StudyId = @StudyId AND StatusId = @StatusId;
  IF @StatusActive = 0
    UPDATE dbo.StudCase SET FinState = @StatusId, GroupId = NULL, Journalansvarlig = NULL 
	WHERE ( StudyId = @StudyId ) AND ( PersonId = @PersonId );
  ELSE
    UPDATE dbo.StudCase SET FinState = @StatusId 
	WHERE ( StudyId = @StudyId ) AND ( PersonId = @PersonId );
END
GO