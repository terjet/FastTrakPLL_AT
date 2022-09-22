SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddAlertResponse]( @AlertId INT, @ActionId CHAR(1) )
AS
BEGIN
 DECLARE @AddTime INT;
 DECLARE @HideUntil DateTime;
 SELECT @AddTime=HideDays FROM dbo.MetaAlertAction WHERE ActionId=@ActionId;
 SET @HideUntil = getdate() + @AddTime;
 INSERT INTO AlertResponse (AlertId,ActionId,HideUntil) VALUES(@AlertId,@ActionId,@HideUntil);
 UPDATE Alert SET HideUntil=@HideUntil WHERE AlertId=@AlertId;
END
GO