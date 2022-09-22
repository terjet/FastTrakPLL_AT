SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateShowMyGroup]( @StudyId INT, @ShowMyGroup BIT )
AS 
BEGIN
  UPDATE StudyUser SET ShowMyGroup=@ShowMyGroup WHERE StudyId=@StudyId AND UserId=USER_ID();
  IF @@ROWCOUNT=0 RAISERROR( 'Du har ikke definert noe gruppe',16,1)
END
GO

DENY EXECUTE ON [dbo].[UpdateShowMyGroup] TO [SingleGroup]
GO