SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddStudyStatus]( @StudyId INT, @StatusId TINYINT, @StatusText VARCHAR(64), @StatusActive INT )
AS
BEGIN
  DECLARE @OldText VARCHAR(64);
  DECLARE @FixedStatus BIT;
  SELECT @OldText = StatusText FROM dbo.StudyStatus WHERE StudyId=@StudyId AND StatusId=@StatusId;
  IF @OldText IS NULL 
	SELECT @FixedStatus = FixedStatus FROM dbo.Study WHERE StudyId=@StudyId
	IF @FixedStatus = 0
		INSERT INTO dbo.StudyStatus (StudyId,StatusId,StatusText,StatusActive ) VALUES( @StudyId,@StatusId,@StatusText,@StatusActive )
  ELSE               
    UPDATE dbo.StudyStatus SET StatusText = @StatusText, StatusActive=@StatusActive WHERE StudyId=@StudyId AND StatusId=@StatusId
END;
GO

GRANT EXECUTE ON [dbo].[AddStudyStatus] TO [superuser]
GO