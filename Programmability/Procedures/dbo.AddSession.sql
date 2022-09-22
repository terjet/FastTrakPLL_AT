SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddSession]( @StudyId INT, @CompName NVARCHAR(128), @CompUser NVARCHAR(128), @CompTime DateTime, @AppVer VARCHAR(50) ) AS
BEGIN
  DECLARE @ExpectedUserName NVARCHAR(128);
  DECLARE @ProfId INT;
  /* Check for existing user in UserList, create if needed */
  IF NOT EXISTS( SELECT 1 FROM dbo.UserList WHERE UserId=USER_ID() )
    INSERT INTO dbo.UserList (UserId,UserName,IsActive) VALUES(USER_ID(),USER_NAME(),1);
  /* Check for existing user in StudyUser, create if needed */
  IF NOT EXISTS( SELECT 1 FROM dbo.StudyUser WHERE StudyId=@StudyId AND UserId=USER_ID() )
    INSERT INTO dbo.StudyUser( StudyId, UserId ) VALUES(@StudyId,USER_ID());
  IF IS_MEMBER( 'SingleGroup' ) = 1  
    UPDATE dbo.StudyUser SET ShowMyGroup = 1, GroupId = ISNULL( GroupId, 0 ) WHERE StudyId = @StudyId AND UserId = USER_ID();
  /* Make sure user name is a match and that the user is active */                              
  SELECT @ExpectedUserName = UserName, @ProfId = ProfId FROM dbo.UserList WHERE ( UserId=USER_ID()) AND ISNULL(IsActive,1)=1;
  /* Add Session if user is active and matches expected name */
  IF @ExpectedUserName IS NULL
  BEGIN
    RAISERROR( 'Brukerkontoen din i FastTrak er ikke aktiv.\nNoter meldingen og kontakt din superbruker eller lokal brukerstøtte.', 16, 1 );
    RETURN -1;
  END
  ELSE IF @ExpectedUserName=USER_NAME() 
  BEGIN
    /* Finally add log entry */
    INSERT INTO dbo.UserLog (StudyId,CompName,CompUser,CompTime,AppVer,ProfId)
      VALUES(@StudyId,@CompName,@CompUser,@CompTime,@AppVer,@ProfId );
    SELECT SCOPE_IDENTITY() AS SessId;
  END
  ELSE
  BEGIN
    RAISERROR( 'Brukernavnet "%s" ser ikke ut til å være gyldig.\nNoter meldingen og kontakt din superbruker eller lokal brukerstøtte.', 16, 1, @ExpectedUserName );
    RETURN -2;
  END
END;
GO

GRANT EXECUTE ON [dbo].[AddSession] TO [DataImport]
GO

GRANT EXECUTE ON [dbo].[AddSession] TO [FastTrak]
GO