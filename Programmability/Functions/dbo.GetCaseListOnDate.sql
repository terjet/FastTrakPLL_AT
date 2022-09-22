SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCaseListOnDate]( @StudyId INT, @CutoffDate DateTime, @CenterId INT ) 
RETURNS @StudCaseList TABLE ( 
  StudyId INT NOT NULL, 
  PersonId INT NOT NULL, 
  CenterId INT NOT NULL,
  GroupId INT NOT NULL,
  GroupName VARCHAR(24),
  StatusId INT NOT NULL,
  StatusText VARCHAR(64) NOT NULL
) AS
BEGIN
  -- Get User's current center if -1 is supplied for CenterId
  IF @CenterId = -1 SELECT @CenterId = CenterId FROM dbo.UserList WHERE UserId=USER_ID();

  INSERT @StudCaseList
  SELECT @StudyId AS StudyId, PersonId, CenterId, NewGroupId AS GroupId, GroupName, NewStatusId AS StatusId, StatusText 
  FROM 
    (
      -- Find the latest change in status and/or group before CutoffDate, using StudCaseLog.
      SELECT sc.StudyId, sc.PersonId, 
        nsg.CenterId,
        scl.NewGroupId, nsg.GroupName, nsg.GroupActive,
        scl.NewStatusId, nss.StatusText, nss.StatusActive,
        scl.ChangedAt,
        RANK() OVER ( PARTITION BY PersonId ORDER BY scl.ChangedAt DESC ) AS OrderBy
      FROM dbo.StudCase sc
      JOIN dbo.StudCaseLog scl ON scl.StudCaseId = sc.StudCaseId
      JOIN dbo.StudyGroup nsg ON nsg.StudyId = sc.StudyId and nsg.GroupId = scl.NewGroupId 
      JOIN dbo.StudyStatus nss ON nss.StudyId = sc.StudyId and nss.StatusId = scl.NewStatusId
      WHERE ( sc.StudyId = @StudyId ) AND ( ChangedAt < @CutoffDate ) 
    ) StudCaseList 
  WHERE OrderBy = 1 AND GroupActive = 1 AND StatusActive=1 AND ISNULL( @CenterId, CenterId ) = CenterId
  ORDER BY PersonId;
  RETURN;
END
GO