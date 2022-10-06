SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddStudyGroup]( @StudyId INT, @GroupName VARCHAR(24), @CenterId INT = NULL ) AS
BEGIN
  DECLARE @GroupId INT;
  SET NOCOUNT ON;       
  IF @CenterId IS NULL 
    SELECT @CenterId = CenterId FROM dbo.UserList WHERE UserId=USER_ID();  
  IF @CenterId IS NULL BEGIN
     INSERT INTO dbo.StudyCenter (CenterName) VALUES('DIPS AS' );
     SET @CenterId=SCOPE_IDENTITY();
     UPDATE dbo.UserList SET CenterId=@CenterId;
  END;      
  SELECT @GroupId = GroupId FROM dbo.StudyGroup WHERE StudyId = @StudyId AND GroupName = @GroupName AND CenterId = @CenterId;
  IF @GroupId IS NULL BEGIN
    SELECT @GroupId = ISNULL(MAX(GroupId),0) FROM dbo.StudyGroup WHERE StudyId=@StudyId;
    SET @GroupId = @GroupId + 1;
    INSERT INTO dbo.StudyGroup(StudyId,GroupId,GroupName,CenterId) VALUES( @StudyId, @GroupId, @GroupName, @CenterId );
  END;
  SELECT @GroupId AS GroupId;
END;
GO

GRANT EXECUTE ON [dbo].[AddStudyGroup] TO [DataImport]
GO

GRANT EXECUTE ON [dbo].[AddStudyGroup] TO [superuser]
GO