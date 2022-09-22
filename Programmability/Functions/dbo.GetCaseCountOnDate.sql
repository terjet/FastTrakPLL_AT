SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCaseCountOnDate]( @StudyId INT, @CutoffDate DateTime, @CenterId INT ) RETURNS INT AS 
BEGIN
  DECLARE @CaseCount INT;
  -- Get User's current center if -1 is supplied for CenterId
  IF @CenterId = -1 SELECT @CenterId = CenterId FROM dbo.UserList WHERE UserId=USER_ID();

  SELECT @CaseCount = COUNT( PersonId ) 
  FROM 
    (
      -- Find the latest change in status and/or group before CutoffDate, using StudCaseLog.
      SELECT sc.PersonId, 
        nsg.CenterId,
        nsg.GroupActive AS NewGroupActive, 
        nss.StatusActive AS NewStatusActive,
        RANK() OVER ( PARTITION BY PersonId ORDER BY scl.ChangedAt DESC ) AS OrderBy
      FROM dbo.StudCase sc
      JOIN dbo.StudCaseLog scl ON scl.StudCaseId = sc.StudCaseId
      JOIN dbo.StudyGroup nsg ON nsg.StudyId=sc.StudyId and nsg.GroupId = scl.NewGroupId 
      JOIN dbo.StudyStatus nss ON nss.StudyId=sc.StudyId and nss.StatusId = scl.NewStatusId
      WHERE ( sc.StudyId = @StudyId ) AND ( ChangedAt < @CutoffDate ) 
    ) StudCaseList  
  WHERE OrderBy = 1 AND NewGroupActive = 1 AND NewStatusActive = 1 AND ISNULL( @CenterId, CenterId ) = CenterId;
  RETURN @CaseCount;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseCountOnDate] TO [FastTrak]
GO