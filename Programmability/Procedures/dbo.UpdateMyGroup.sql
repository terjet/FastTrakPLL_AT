SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateMyGroup]( @StudyId INT,@GroupId INT )
AS
BEGIN
  IF NOT EXISTS( SELECT UserId FROM StudyUser WHERE UserId=USER_ID() AND StudyId=@StudyId )
    INSERT INTO StudyUser (StudyId,UserId,GroupId) VALUES( @StudyId,USER_ID(),@GroupId )
  ELSE
    UPDATE StudyUser SET GroupId=@GroupId WHERE StudyId=@StudyId AND UserId=USER_ID();
END
GO

GRANT EXECUTE ON [dbo].[UpdateMyGroup] TO [FastTrak]
GO