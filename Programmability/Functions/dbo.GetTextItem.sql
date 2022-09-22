SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetTextItem]( @ScopeName varchar(24),@KeyName varchar(64) ) RETURNS varchar(512)
AS
BEGIN
  DECLARE @TextValue varchar(512);
  SELECT @TextValue = TextValue FROM TextItems WHERE ScopeName=@ScopeName AND Keyname=@KeyName;
  IF @TextValue IS NULL
    SET @TextValue = '@' + ISNULL(@ScopeName,'') + '.' + ISNULL(@KeyName,'');
  RETURN @TextValue;
END
GO