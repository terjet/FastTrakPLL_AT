SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClinTouch]( @SessId INT, @PersonId INT, @EventNum INT, @FormId INT )
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @TouchId INT;
  DECLARE @EventId INT;
  DECLARE @StudyId INT;
  SET @TouchId = NULL;
  SET @EventId = NULL;
  /* Find EventId */
  SET @StudyId=dbo.GetStudyId(@SessId);
  IF NOT @StudyId IS NULL 
  BEGIN
    /* Find the event matching the input */
    SELECT @EventId = EventId FROM ClinEvent WHERE StudyId=@StudyId
      AND PersonId=@PersonId AND EventNum=@EventNum;
    /* Create event if it doesn't exists */
    IF @EventId IS NULL BEGIN
      INSERT INTO ClinEvent (StudyId,PersonId,EventNum)
        VALUES( @StudyId,@PersonId,@EventNum);
      SET @EventId=SCOPE_IDENTITY();
    END
    ELSE BEGIN
      /* Based on EventId, find TouchId */
      SELECT @TouchId=TouchId FROM ClinTouch WHERE
        EventId=@EventId AND SessId=@SessId AND FormId=@FormId;
    END;
    IF @TouchId IS NULL BEGIN
      /* This event has not been touched in this session */
      INSERT INTO ClinTouch (SessId,EventId,FormId) VALUES(@SessId,@EventId,@FormId)
      SET @TouchId=SCOPE_IDENTITY();
    END;
    UPDATE StudCase SET LastWrite = GetDate() WHERE StudyId=@StudyId AND PersonId=@PersonId;
  END;
  SELECT ISNULL(@TouchId,-1) AS TouchId, ISNULL(@EventId,-1) AS EventId;
END
GO

GRANT EXECUTE ON [dbo].[GetClinTouch] TO [FastTrak]
GO