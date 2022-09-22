SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetStudyId]( @SessId INT ) RETURNS INT
AS
BEGIN
  DECLARE @StudyId INT;
  SELECT @StudyId = StudyId FROM dbo.UserLog WHERE SessId=@SessId AND ClosedAt IS NULL AND UserId=USER_ID();
  RETURN (@StudyId);
END
GO

GRANT EXECUTE ON [dbo].[GetStudyId] TO [FastTrak]
GO