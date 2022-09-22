SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[UpdateStudyMetadata] AS
BEGIN
  DECLARE @StudyId AS INT;
  DECLARE @CenterId AS INT;
  DECLARE @GroupId AS INT;
  SELECT @StudyId=MAX(StudyId) FROM Study WHERE StudName='NDV';
  IF @StudyId IS NULL 
    PRINT 'Studien er ikke definert' 
  ELSE 
  BEGIN
    SELECT @CenterId=CenterId FROM UserList WHERE UserId=user_id();
    PRINT 'NDV Studien er definert'
    IF ( SELECT COUNT(*) FROM StudyStatus WHERE StudyId=@StudyId ) = 0 
    BEGIN
      INSERT INTO StudyStatus (StudyId,StatusId,StatusText,StatusActive)
        VALUES (@StudyId,1,'Aktiv',1)
      INSERT INTO StudyStatus (StudyId,StatusId,StatusText,StatusActive)
        VALUES (@StudyId,2,'Mors',0)
      INSERT INTO StudyStatus (StudyId,StatusId,StatusText,StatusActive)
        VALUES (@StudyId,3,'Flyttet',0)
      INSERT INTO StudyStatus (StudyId,StatusId,StatusText,StatusActive)
        VALUES (@StudyId,4,'Avsluttet',0)
    END;             
    IF NOT EXISTS (SELECT GroupId FROM StudyGroup WHERE StudyId=@StudyId AND CenterId=@CenterId AND GroupName LIKE 'Test%' ) EXEC AddStudyGroup @StudyId,'Testpasienter',@CenterId;
    IF NOT EXISTS (SELECT GroupId FROM StudyGroup WHERE StudyId=@StudyId AND CenterId=@CenterId AND GroupName LIKE 'Tilsyn%' ) EXEC AddStudyGroup @StudyId,'Tilsyn',@CenterId
    IF NOT EXISTS (SELECT GroupId FROM StudyGroup WHERE StudyId=@StudyId AND CenterId=@CenterId AND GroupName LIKE 'Polikl%' ) EXEC AddStudyGroup @StudyId,'Poliklinikk',@CenterId
    UPDATE StudyGroup SET GroupActive=0 WHERE StudyId=@StudyId AND GroupName LIKE 'Test%';
    UPDATE StudyGroup SET GroupActive=0 WHERE StudyId=@StudyId AND GroupName LIKE 'Tilsyn%';
    UPDATE StudyGroup SET GroupActive=1 WHERE StudyId=@StudyId AND GroupName LIKE 'Polikl%';
  END
END
GO

DENY EXECUTE ON [NDV].[UpdateStudyMetadata] TO [ReadOnly]
GO

GRANT EXECUTE ON [NDV].[UpdateStudyMetadata] TO [superuser]
GO