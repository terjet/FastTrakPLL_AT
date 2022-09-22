SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateUserCenter]( @UserId INT, @CenterId INT ) AS
BEGIN
  IF @UserId = 0 SET @UserId=user_id();
  UPDATE UserList SET CenterId=@CenterId WHERE UserId=@UserId AND ISNULL(CenterId,0)<>@CenterId;
END
GO