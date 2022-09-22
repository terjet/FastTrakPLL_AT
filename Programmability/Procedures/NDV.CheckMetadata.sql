SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[CheckMetadata] AS
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
    IF ( SELECT COUNT(*) FROM StudyGroup WHERE StudyId=@StudyId AND GroupName LIKE 'Test%') = 0 
    BEGIN
      SELECT @GroupId = ISNULL(MAX(GroupId),0) FROM StudyGroup WHERE StudyId=@StudyId;
      SET @GroupId=@GroupId + 1;
      INSERT INTO StudyGroup(StudyId,GroupId,GroupName,CenterId)
        VALUES (@StudyId,@GroupId,'Testpasienter',@CenterId)
    END
    UPDATE StudyGroup SET GroupActive=1 WHERE StudyId=@StudyId AND GroupName LIKE 'Test%';
  END
END
GO