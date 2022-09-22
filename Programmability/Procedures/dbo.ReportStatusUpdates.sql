SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportStatusUpdates]( @StudyId INT, @StartAt DateTime = NULL )
AS
BEGIN
  IF @StartAt IS NULL SET @StartAt = getdate()-365; 
  SELECT DISTINCT pat.NationalId,pat.FullName,sgn.GroupName as GroupNow,sgo.GroupName as GroupThen,
    scl.ChangedAt, sso.StatusText as OldStatus,ssn.StatusText as NewStatus,
    p.Signature
  FROM StudCaseLog scl
  JOIN StudCase sc on sc.StudCaseId=scl.StudCaseId AND sc.StudyId=@StudyId
  JOIN StudCase scn on scn.StudCaseId=sc.StudCaseId AND scn.StudyId=@StudyId
  JOIN Person pat ON pat.PersonId=sc.PersonId
  JOIN UserList ul on ul.UserId=scl.ChangedBy
  JOIN UserList my on my.UserId=user_id()
  JOIN StudyStatus sso on sso.StatusId=scl.OldStatusId and sso.StudyId=sc.StudyId
  JOIN StudyStatus ssn on ssn.StatusId=scl.NewStatusId and ssn.StudyId=sc.StudyId
  JOIN Person p on p.PersonId=ul.PersonId and ul.UserId=scl.ChangedBy
  LEFT OUTER JOIN StudyGroup sgn ON sgn.StudyId=sc.StudyId AND sgn.GroupId=scl.NewGroupId 
  LEFT OUTER JOIN StudyGroup sgo ON sgo.StudyId=sc.StudyId AND sgo.GroupId=scl.OldGroupId
  WHERE ( scl.OldStatusId <> scl.NewStatusId ) AND ( scl.ChangedAt > @StartAt )
  AND (( sgn.CenterId=my.CenterId AND sgn.GroupActive=1) OR ( sgo.CenterId=my.CenterId AND sgo.GroupActive = 1 ))
  ORDER BY NewStatus,ChangedAt desc
END
GO

GRANT EXECUTE ON [dbo].[ReportStatusUpdates] TO [FastTrak]
GO