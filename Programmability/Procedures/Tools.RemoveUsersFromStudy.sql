SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[RemoveUsersFromStudy]( @StudyName VARCHAR(24) )
AS
BEGIN
  DECLARE @StudyId INT;
  DECLARE @GroupId INT;        
  /* Find group and Study */
  SELECT @StudyId = StudyId FROM Study WHERE StudyName=@StudyName;
  SELECT @GroupId = GroupId from StudyGroup sg 
    JOIN StudyCenter c on c.CenterId=sg.CenterId 
    WHERE c.CenterName='Emetra AS' AND sg.StudyId=@StudyId;
  /* Move users */  
  IF ( NOT @StudyId IS NULL) AND ( NOT @GroupId IS NULL ) 
    UPDATE StudCase SET GroupId=@GroupId WHERE StudyId = @StudyId AND PersonId IN
      ( SELECT sc.PersonId from StudCase sc
        JOIN UserList ul ON ul.PersonId=sc.PersonId
        WHERE sc.StudyId=@StudyId );
END;
GO