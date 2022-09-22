SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddStudyGroup]( @StudyId INT, @GroupName varchar(24), @CenterId INT = NULL )
AS
BEGIN
  DECLARE @GroupId INT;
  SET NOCOUNT ON;       
  IF @CenterId IS NULL 
    SELECT @CenterId=CenterId FROM UserList WHERE UserId=USER_ID();  
  IF @CenterId IS NULL BEGIN
     INSERT INTO StudyCenter (CenterName) VALUES('FastTrak User Site' );
     SET @CenterId=SCOPE_IDENTITY();
     UPDATE UserList SET CenterId=@CenterId;
  END;      
  SELECT @GroupId = GroupId FROM StudyGroup WHERE StudyId=@StudyId AND GroupName=@GroupName AND CenterId=@CenterId;
  IF @GroupId IS NULL BEGIN
    SELECT @GroupId = ISNULL(MAX(GroupId),0) FROM StudyGroup WHERE StudyId=@StudyId;
    SET @GroupId = @GroupId + 1;
    INSERT INTO StudyGroup(StudyId,GroupId,GroupName,CenterId) VALUES( @StudyId,@GroupId,@GroupName,@CenterId)
  END;
  SELECT @GroupId AS GroupId;
END;
GO

GRANT EXECUTE ON [dbo].[AddStudyGroup] TO [DataImport]
GO

GRANT EXECUTE ON [dbo].[AddStudyGroup] TO [superuser]
GO