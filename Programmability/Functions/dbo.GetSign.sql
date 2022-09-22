SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetSign]( @UserId INT ) RETURNS varchar(6)
AS
BEGIN
  DECLARE @RetVal varchar(6);
  SELECT @RetVal = Signature FROM Person p JOIN UserList ul ON ul.PersonId = p.PersonId 
    WHERE ul.UserId=@UserId;
  IF @RetVal IS NULL
    SET @RetVal = user_name(@UserId);
  RETURN @RetVal;
END
GO