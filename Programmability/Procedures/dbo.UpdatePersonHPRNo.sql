SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdatePersonHPRNo]( @PersonId INT, @HPRNo INT ) AS
BEGIN
  SET NOCOUNT ON;
  -- Must be superuser or dbo to update somebody elses HPRNo
  IF ( IS_ROLEMEMBER('Superuser') + IS_ROLEMEMBER('db_owner') = 0 ) 
  AND ( dbo.GetMyPersonId() <> @PersonId ) 
  BEGIN
    RAISERROR( 'Du kan bare endre ditt eget HPR-nummer!',16,1 )
    RETURN -1;
  END;
  UPDATE dbo.Person SET HPRNo = NULLIF(@HPRNo,0) WHERE PersonId = @PersonId;
END
GO