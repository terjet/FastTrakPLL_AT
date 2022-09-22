SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddStudy]( @StudyName varchar(24) ) AS
BEGIN
  SET NOCOUNT ON;        
  DECLARE @StudyId INT;                                            
  DECLARE @CenterId INT;
  IF NOT EXISTS( SELECT StudyId FROM Study WHERE StudName = @StudyName )
  BEGIN     
    SELECT @CenterId=CenterId FROM UserList WHERE UserId=USER_ID();
    INSERT INTO Study ( StudName ) VALUES (@StudyName);
    SET @StudyId=SCOPE_IDENTITY();
    EXEC AddStudyGroup @StudyId,'Ugruppert',@CenterId; 
  END;
  SELECT StudyId FROM Study WHERE StudName=@StudyName;
END;
GO

GRANT EXECUTE ON [dbo].[AddStudy] TO [DataImport]
GO

GRANT EXECUTE ON [dbo].[AddStudy] TO [FastTrak]
GO