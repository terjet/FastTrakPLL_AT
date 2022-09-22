SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClinEvents]( @SessId INT, @PersonId INT ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @ProfRel INT;
  DECLARE @StudyId INT;
  DECLARE @CenterId INT;
  SET @StudyId=dbo.GetStudyId( @SessID )
  IF @StudyId IS NULL BEGIN
    SELECT -1,'Invalid Session'
  END
  ELSE BEGIN            
    /* Find the center, same as user center */
    SELECT @CenterId=sg.GroupId FROM StudCase sc 
    JOIN StudyGroup sg ON sg.GroupId=sc.GroupId AND sc.PersonId=@PersonId
    JOIN UserList ul ON ul.CenterId=sg.CenterId;
    IF @CenterId IS NULL
      RAISERROR( 'Person not in your center',16,1)
    ELSE BEGIN 
      INSERT INTO CaseLog (PersonId,LogType,LogText)
      VALUES( @PersonId,'LESE','Journal lest av ' + USER_NAME() );
      SELECT e.EventNum,cf.FormId,e.EventId,e.EventTime FROM ClinEvent e
      JOIN ClinForm cf on cf.EventId=e.EventId
      WHERE e.PersonId=@PersonId AND e.StudyId=@StudyId;
    END;
  END;
END
GO