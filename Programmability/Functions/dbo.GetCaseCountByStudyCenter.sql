SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCaseCountByStudyCenter]( @StudyId INT, @CenterId INT) RETURNS INT
AS
BEGIN
  DECLARE @RetVal INT;
  SELECT @RetVal = count(*) FROM StudCase sc
    JOIN StudyGroup sg on sg.StudyId=sc.StudyId AND sg.GroupId=sc.GroupId AND sg.CenterId=@CenterId AND sg.GroupActive=1
    JOIN StudyStatus ss on ss.StudyId=sc.StudyId AND sc.FinState=ss.StatusId and ss.StatusActive=1 
    JOIN StudyCenter c ON c.CenterId=sg.CenterId
  WHERE sc.StudyId=@StudyId;
  RETURN @RetVal
END
GO

GRANT EXECUTE ON [dbo].[GetCaseCountByStudyCenter] TO [FastTrak]
GO