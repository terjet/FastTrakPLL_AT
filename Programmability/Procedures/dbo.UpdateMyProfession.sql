SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateMyProfession]( @ProfId INT ) AS
BEGIN
  IF NOT EXISTS( SELECT 1 FROM AccessCtrl.UserProfession WHERE ProfId = @ProfId )
    RAISERROR( 'Du kan dessverre ikke bytte til dette yrket.\nKontakt brukerstøtte hvis du har behov for det.', 16, 1 )
  ELSE
    UPDATE dbo.UserList SET ProfId = @ProfId WHERE UserId = USER_ID();
END
GO

GRANT EXECUTE ON [dbo].[UpdateMyProfession] TO [ChangeProfession]
GO

DENY EXECUTE ON [dbo].[UpdateMyProfession] TO [Systemansvarlig]
GO