SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetActiveCasesAtStudyCenter]( @StudyId INT, @CenterId INT, @Portion INT = NULL ) RETURNS DECIMAL(5,1)
AS
BEGIN
  DECLARE @RetVal DECIMAL(5,2);
  SELECT @RetVal = count(*) FROM StudCase sc
  JOIN StudyGroup sg on sg.StudyId=sc.StudyId and sg.GroupId=sc.GroupId AND sg.CenterId=@CenterId
  JOIN StudyStatus ss on ss.StudyId=sc.StudyId AND sc.FinState=ss.StatusId
  JOIN StudyCenter c ON c.CenterId=sg.CenterId
  AND ss.StatusActive=1 AND sc.StudyId=@StudyId;
  IF NOT @Portion IS NULL SET @RetVal=@Portion/@RetVal;
  RETURN @RetVal
END
GO

GRANT EXECUTE ON [dbo].[GetActiveCasesAtStudyCenter] TO [FastTrak]
GO