SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdatePersonGSM] ( @PersonId INT, @GSM VARCHAR(16)) AS
BEGIN
  -- Must be superuser or dbo to update somebody elses GSM
  IF (is_rolemember('superuser') = 0 AND is_rolemember('db_owner') = 0 AND dbo.GetMyPersonId() <> @PersonId) 
  BEGIN
    RAISERROR( 'Du kan kun endre ditt eget telefonnummer!',16,1 )
    RETURN -1;
  END;
  UPDATE dbo.Person SET GSM = @GSM WHERE PersonId = @PersonId
END
GO