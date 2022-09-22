SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetPatientLocationHistory] (@PersonId INTEGER, @StudyId INTEGER = NULL) AS
BEGIN
  SELECT s.StudName, scl.ChangedAt, sgold.GroupName AS GroupFrom, scold.CenterName AS CenterFrom, sgnew.GroupName AS GroupTo, scnew.CenterName AS CenterTo
  FROM dbo.Person p
  JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId
  JOIN dbo.Study s ON s.StudyId = sc.StudyId
  LEFT JOIN dbo.StudCaseLog scl ON scl.StudCaseId = sc.StudCaseId
  LEFT JOIN dbo.StudyGroup sgold ON sgold.GroupId = scl.OldGroupId AND sgold.StudyId = sc.StudyId
  LEFT JOIN dbo.StudyCenter scold ON scold.CenterId = sgold.CenterId
  LEFT JOIN dbo.StudyGroup sgnew ON sgnew.GroupId = scl.NewGroupId AND sgnew.StudyId = sc.StudyId
  LEFT JOIN dbo.StudyCenter scnew ON scnew.CenterId = sgnew.CenterId
  WHERE p.PersonId = @PersonId AND (ISNULL(@StudyId, sc.StudyId) = sc.StudyId) AND
  ISNULL(scl.NewGroupId, -1) <> ISNULL(scl.OldGroupId, -1)
  ORDER BY scl.ChangedAt DESC, sc.CreatedAt DESC;
END
GO

GRANT EXECUTE ON [dbo].[GetPatientLocationHistory] TO [FastTrak]
GO