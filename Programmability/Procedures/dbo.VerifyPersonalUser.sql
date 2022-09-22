SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[VerifyPersonalUser] AS
BEGIN
  DECLARE @UserId INT;
  DECLARE @UserName SYSNAME;
  DECLARE @RealName SYSNAME;
  -- User validation
  IF ISNULL(USER_ID(), 0) = 0
  BEGIN
    RAISERROR ( 'Du mangler dessverre en brukerkonto i systemet. Be en superbruker\nom å legge deg til som bruker i applikasjonen!', 16, 1);
    RETURN -4;
  END;
  SET @RealName = USER_NAME();
  SELECT @UserId = UserId, @UserName = ISNULL(UserName, '(mangler)')
  FROM dbo.UserList
  WHERE UserId = USER_ID();
  IF @UserId IS NULL
  BEGIN
    SET @UserId = USER_ID();
    SET @UserName = @RealName;
    INSERT INTO dbo.UserList (UserId, UserName)
      VALUES (@UserId, @UserName)
  END
  ELSE
  IF (@UserName <> @RealName) OR (@UserName IS NULL)
  BEGIN
    RAISERROR ('Forventet [%s] og virkelig brukernavn [%s] er forskjellig.\nDu kan ikke bruke applikasjonen før dette er rettet.\nDu bør kontakte DIPS AS på telefon 7559 2200 snarest!', 16, 1, @UserName, @RealName)
    RETURN -1;
  END;
END;
GO