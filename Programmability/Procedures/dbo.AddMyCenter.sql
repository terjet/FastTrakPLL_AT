﻿SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddMyCenter]( @CenterId INT ) AS
BEGIN
  UPDATE UserList SET CenterId=@CenterId WHERE UserId=USER_ID() AND CenterId IS NULL
END
GO