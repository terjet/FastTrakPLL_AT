SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[AddMulticenterAccess]( @UserName SYSNAME, @C1 INT, @C2 INT, @C3 INT, @C4 INT, @C5 INT, @C6 INT, @C7 INT, @C8 INT, @CommentText VARCHAR(32) ) AS
BEGIN
  SET NOCOUNT ON;
  SET XACT_ABORT ON;
  DECLARE @DomainUser SYSNAME = CONCAT( DEFAULT_DOMAIN(), '\', @UserName );
  DECLARE @UserId INT = USER_ID(@DomainUser);
  DECLARE @FromDate DATE = GETDATE();
  DECLARE @ToDate DATE = GETDATE() + 365;
  IF @UserId IS NULL BEGIN
      RAISERROR( 'Invalid username: %s.', 16, 1, @UserName );
	  RETURN;
  END;
  BEGIN TRY
    IF NOT @C1 IS NULL EXEC dbo.AddUserCenterAccess @UserId, @C1, @FromDate, @ToDate, @CommentText;
    IF NOT @C2 IS NULL EXEC dbo.AddUserCenterAccess @UserId, @C2, @FromDate, @ToDate, @CommentText;  
    IF NOT @C3 IS NULL EXEC dbo.AddUserCenterAccess @UserId, @C3, @FromDate, @ToDate, @CommentText;
    IF NOT @C4 IS NULL EXEC dbo.AddUserCenterAccess @UserId, @C4, @FromDate, @ToDate, @CommentText;
    IF NOT @C5 IS NULL EXEC dbo.AddUserCenterAccess @UserId, @C5, @FromDate, @ToDate, @CommentText;
    IF NOT @C6 IS NULL EXEC dbo.AddUserCenterAccess @UserId, @C6, @FromDate, @ToDate, @CommentText;
    IF NOT @C7 IS NULL EXEC dbo.AddUserCenterAccess @UserId, @C7, @FromDate, @ToDate, @CommentText;
    IF NOT @C8 IS NULL EXEC dbo.AddUserCenterAccess @UserId, @C8, @FromDate, @ToDate, @CommentText;
  END TRY
  BEGIN CATCH
    PRINT CONCAT( 'Failed to add access to one or more centers for ', @UserName, ': ', ERROR_MESSAGE() );
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	RETURN;
  END CATCH;
END
GO