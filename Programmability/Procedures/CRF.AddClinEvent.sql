SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[AddClinEvent]( @StudyId INT, @PersonId INT, @EventNum INT, @GroupId INT, @StatusId INT, @EventId INT OUTPUT, @IsNewEvent BIT OUTPUT ) AS
BEGIN
  SET NOCOUNT ON;
  SET @IsNewEvent = 0;
  SELECT @EventId = EventId FROM dbo.ClinEvent 
    WHERE StudyId = @StudyId AND PersonId = @PersonId AND EventNum = @EventNum;
  IF @EventId IS NULL 
  BEGIN 
    SET @IsNewEvent = 1;
    INSERT INTO dbo.ClinEvent ( StudyId, PersonId, EventNum, GroupId ) VALUES ( @StudyId, @PersonId, @EventNum, @GroupId );
    SET @EventId = SCOPE_IDENTITY();
  END;
END;
GO

GRANT EXECUTE ON [CRF].[AddClinEvent] TO [FastTrak]
GO