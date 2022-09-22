SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateAlertResponse]( @AlertId INT, @HideUntil DateTime )
AS
BEGIN
 INSERT INTO AlertResponse (AlertId,ActionId,HideUntil) VALUES(@AlertId,'N',@HideUntil);
 UPDATE Alert SET HideUntil=@HideUntil WHERE AlertId=@AlertId;
END
GO

GRANT EXECUTE ON [dbo].[UpdateAlertResponse] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateAlertResponse] TO [ReadOnly]
GO