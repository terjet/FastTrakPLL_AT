SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateDefaultPopulation]( @StudyId INT, @ProcId INT )
AS 
BEGIN
  UPDATE StudyUser SET CaseList=@ProcId WHERE StudyId=@StudyId AND UserId=USER_ID();
  IF @@ROWCOUNT = 0 INSERT INTO StudyUser (StudyId,UserId,CaseList) VALUES( @StudyId, USER_ID(),@ProcId )
END
GO

GRANT EXECUTE ON [dbo].[UpdateDefaultPopulation] TO [FastTrak]
GO