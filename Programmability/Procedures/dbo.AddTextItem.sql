SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddTextItem]( @ScopeName varchar(24), @KeyName varchar(64), @TextValue varchar(512) )
AS
BEGIN
  UPDATE TextItems SET TextValue=@TextValue WHERE ScopeName=@ScopeName AND KeyName=@KeyName;
  IF @@ROWCOUNT = 0
    INSERT INTO TextItems(ScopeName,KeyName,TextValue )
    VALUES( @ScopeName,@KeyName,@TextValue )
END;
GO