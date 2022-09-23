SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportStatusUpdates]( @StudyId INT, @StartAt DateTime = NULL, @StopAt DateTime = NULL ) AS
BEGIN
 IF @StartAt IS NULL SET @StartAt = GetDate()-365;
 IF @StopAt IS NULL SET @StopAt = GetDate();
 SELECT DISTINCT pat.NationalId,pat.FullName,
   ISNULL(sgn.GroupName,'(ingen gruppe)') AS GroupNow, ISNULL(sgo.GroupName,'(ingen gruppe)') AS GroupThen,
   scl.ChangedAt, ISNULL(sso.StatusText,'(ingen)') AS OldStatus, ISNULL(ssn.StatusText,'(ingen') AS NewStatus,
   up.Signature,sc.StudCaseId
 FROM dbo.StudCaseLog scl
 JOIN dbo.StudCase sc on sc.StudCaseId=scl.StudCaseId AND sc.StudyId=@StudyId
 JOIN dbo.StudCase scn on scn.StudCaseId=sc.StudCaseId AND scn.StudyId=@StudyId
 JOIN dbo.Person pat ON pat.PersonId=sc.PersonId
 JOIN dbo.UserList ul on ul.UserId=scl.ChangedBy
 JOIN dbo.Person up on up.PersonId=ul.PersonId and ul.UserId=scl.ChangedBy
 JOIN dbo.UserList my on my.UserId=USER_ID()
 LEFT JOIN dbo.StudyStatus ssn on ssn.StudyId=sc.StudyId AND ssn.StatusId=scl.NewStatusId 
 LEFT JOIN dbo.StudyStatus sso on sso.StudyId=sc.StudyId AND sso.StatusId=scl.OldStatusId
 LEFT JOIN dbo.StudyGroup sgn ON sgn.StudyId=sc.StudyId AND sgn.GroupId=scl.NewGroupId
 LEFT JOIN dbo.StudyGroup sgo ON sgo.StudyId=sc.StudyId AND sgo.GroupId=scl.OldGroupId
 LEFT JOIN dbo.StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId = sc.GroupId
 WHERE ( ( ISNULL( scl.OldStatusId, -1 ) <> ISNULL( scl.NewStatusId,-1 ) )
   AND ( scl.ChangedAt >= @StartAt ) AND ( scl.ChangedAt < @StopAt )
   AND   ( 
           ( ISNULL(sgn.CenterId,0) = my.CenterId AND ISNULL( sgn.GroupActive, 0 ) = 1 ) OR 
           ( ISNULL(sgo.CenterId,0) = my.CenterId AND ISNULL( sgo.GroupActive, 0 ) = 1 ) OR 
           ( ISNULL(sg.CenterId,0) = my.CenterId AND ISNULL( sg.GroupActive, 0 ) = 1 )
          )
       )
 ORDER BY NewStatus,ChangedAt desc
END
GO

GRANT EXECUTE ON [dbo].[ReportStatusUpdates] TO [FastTrak]
GO