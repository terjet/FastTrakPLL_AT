SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[AddPandemicUser]( @UserName SYSNAME, @CenterId INT, @ProfType VARCHAR(3), 
  @SuperUserRole BIT, @PandemicRole BIT, @ChangeWorksiteRole BIT ) AS
BEGIN
  SET NOCOUNT ON;
  SET XACT_ABORT ON;
  DECLARE @DomainUser SYSNAME;
  SET @DomainUser = CONCAT( DEFAULT_DOMAIN(), '\', @UserName );
  DECLARE @ProfId INT;
  SELECT @ProfId = ProfId FROM dbo.MetaProfession WHERE ProfType = @ProfType;
  BEGIN TRY
    IF USER_ID(@DomainUser) IS NULL 
      EXEC AdminTool.AddUser @DomainUser, @ProfId, @CenterId
	ELSE
	  PRINT CONCAT('USER ', @DomainUser, ' already exists.' );
  END TRY
  BEGIN CATCH
    PRINT ERROR_MESSAGE();
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	RETURN;
  END CATCH;
  IF @SuperUserRole = 1 EXEC dbo.AddRoleMember 'Superuser', @DomainUser; 
  IF @PandemicRole = 1 EXEC dbo.AddRoleMember 'Pandemic', @DomainUser; 
  IF @ChangeWorksiteRole = 1 EXEC dbo.AddRoleMember 'ChangeWorksite', @DomainUser; 
END
GO