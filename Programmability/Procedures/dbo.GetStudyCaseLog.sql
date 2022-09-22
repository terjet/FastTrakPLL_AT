SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetStudyCaseLog]( @StudyId INT, @PersonId INT ) AS
BEGIN
  SELECT scl.StudCaseLogId, sc.PersonId,
    scOld.CenterId AS OldCenterId, scNew.CenterId AS NewCenterId, scOld.CenterName AS OldCenterName, scNew.CenterName AS NewCenterName,
    scl.OldGroupId, scl.NewGroupId, sgOld.GroupName AS OldGroupName, sgNew.GroupName AS NewGroupName,
    scl.OldStatusId, scl.NewStatusId, ssOld.StatusText AS OldStatusText, ssNew.StatusText AS NewStatusText, ssOld.StatusActive AS OldStatusActive, ssNew.StatusActive AS NewStatusActive,
	scl.OldJournalansvarlig, scl.NewJournalansvarlig,
    sc.StudyId, scl.ChangedBy, ChangedAt 
  FROM dbo.StudCaseLog scl
  JOIN dbo.StudCase sc ON sc.StudCaseId = scl.StudCaseId
  FULL OUTER JOIN dbo.StudyGroup sgOld ON sgOld.GroupId = scl.OldGroupId AND sc.StudyId = sgOld.StudyId
  FULL OUTER JOIN dbo.StudyGroup sgNew ON sgNew.GroupId = scl.NewGroupId AND sc.StudyId = sgNew.StudyId
  FULL OUTER JOIN dbo.StudyStatus ssOld ON ssOld.StatusId = scl.OldStatusId AND sc.StudyId = ssOld.StudyId
  FULL OUTER JOIN dbo.StudyStatus ssNew ON ssNew.StatusId = scl.NewStatusId AND sc.StudyId = ssNew.StudyId
  LEFT JOIN dbo.StudyCenter scOld ON sgOld.CenterId = scOld.CenterId
  LEFT JOIN dbo.StudyCenter scNew ON sgNew.CenterId = scNew.CenterId  
  WHERE sc.PersonId = @PersonId AND sc.StudyId = @StudyId;
END
GO

GRANT EXECUTE ON [dbo].[GetStudyCaseLog] TO [FastTrak]
GO