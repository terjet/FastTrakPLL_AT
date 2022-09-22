SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateMyCenter]( @CenterId INT ) AS
BEGIN
  IF EXISTS(SELECT * FROM dbo.MyStudyCenters MSC WHERE MSC.CenterId=@CenterId)
    UPDATE dbo.UserList SET CenterId=@CenterId WHERE UserId=USER_ID();
  ELSE
    RAISERROR('Du har ikke rettigheter til å  endre arbeidssted.', 16, 1);
END
GO