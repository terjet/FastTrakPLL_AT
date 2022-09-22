SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Pandemic].[AddUser]( @UserName SYSNAME, @CenterId INT, @ProfType VARCHAR(3), @SuperUserRole BIT, @PandemicRole BIT ) AS
BEGIN
  DECLARE @ProfId INT;
  DECLARE @ProfName VARCHAR(32);
  -- Find profession based on ProfType
  SELECT @ProfId = ProfId, @ProfName = ProfName 
    FROM dbo.MetaProfession WHERE ProfType = @ProfType
  IF USER_ID(@UserName) IS NULL
    EXEC AdminTool.AddUser @UserName, @ProfId, @CenterId;
  -- Use our procedure to make sure that logs are updated (who granted this role).
  IF @SuperUserRole = 1 EXEC dbo.AddRoleMember 'Support', @UserName;
  IF @PandemicRole = 1 EXEC dbo.AddRoleMember 'Pandemic', @UserName;
END;
GO