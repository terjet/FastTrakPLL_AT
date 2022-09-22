SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateAlertResponse]( @AlertId INT, @HideUntil DateTime )
AS
BEGIN
 INSERT INTO AlertResponse (AlertId,ActionId,HideUntil) VALUES(@AlertId,'N',@HideUntil);
 UPDATE Alert SET HideUntil=@HideUntil WHERE AlertId=@AlertId;
END
GO