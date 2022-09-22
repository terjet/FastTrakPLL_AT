SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddAlertReminder]( @AlertLevel INT,
 @AlertHeader varchar(64), @AlertMessage varchar(512), @UserId INT = NULL ) 
AS
BEGIN
  IF @UserId IS NULL SET @UserId=USER_ID();
  INSERT INTO dbo.Alert (PersonId,UserId,AlertLevel,AlertClass,AlertFacet, AlertHeader,AlertMessage,AlertButtons)
    VALUES (0,@UserId,@AlertLevel,'REMINDER','Undefined',@AlertHeader,@AlertMessage,'TWMHYF')
END
GO

GRANT EXECUTE ON [dbo].[AddAlertReminder] TO [FastTrak]
GO