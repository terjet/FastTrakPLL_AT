SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[CaseAccessLog]( @StudyId INT, @StartAt DATETIME, @StopAt DATETIME, @UserName SYSNAME, @CenterId INT, @PersonId INT ) AS
BEGIN
  SELECT a.*,           
    aat.AccessTypeText,             
    p.FullName,

    CONVERT( DATE, a.CreatedAt ) AS CreatedAtDay,

    CASE
      WHEN a.OpenInSeconds > 300 THEN CONCAT(a.OpenInSeconds / 60, ' m')
      WHEN a.OpenInSeconds > 18000 THEN CONCAT(a.OpenInSeconds / 3600, ' t')
      WHEN a.OpenInSeconds IS NULL THEN '(ukjent)'
      ELSE CONCAT(a.OpenInSeconds, ' s')
    END AS OpenDuration,

    SUBSTRING( a.UserName, CHARINDEX('\', a.UserName, 0) + 1, LEN(a.UserName) - CHARINDEX('\', a.UserName,0)) AS UserNameShort

  FROM 
  (
    SELECT 
      ca.RowId, ca.PersonId, ca.CreatedAt, ca.OpenInSeconds, ca.AccessTypeId,
      csl.NewGroupId,
      sg.GroupName,
      sc1.CenterId, sc1.CenterName,
      ul.UserName,
      ROW_NUMBER() OVER ( PARTITION BY ca.RowId ORDER BY csl.ChangedAt DESC ) AS ReverseOrder
    FROM AuditLog.CaseAccess ca
      JOIN dbo.StudCase sc ON sc.PersonId = ca.PersonId AND sc.StudyId = @StudyId
      JOIN dbo.StudCaseLog csl ON csl.StudCaseId = sc.StudCaseId
      JOIN dbo.StudyGroup sg ON sg.GroupId = csl.NewGroupId AND sg.StudyId = sc.StudyId
      JOIN dbo.StudyCenter sc1 ON sc1.CenterId = sg.CenterId
      JOIN dbo.UserList ul ON ul.UserId = ca.CreatedBy
    WHERE ( ca.CreatedAt >= csl.ChangedAt ) AND ( ca.CreatedAt >= @StartAt AND ca.CreatedAt < @StopAt )
      AND ( ca.PersonId = ISNULL( @PersonId, ca.PersonId ) )
      AND ( sc1.CenterId = ISNULL( @CenterId, sc1.CenterId) )
  ) a 
  JOIN AuditLog.AccessType aat ON aat.AccessTypeId = a.AccessTypeId
  JOIN dbo.Person p ON p.PersonId = a.PersonId
  WHERE a.ReverseOrder = 1
    AND ( a.UserName LIKE CONCAT('%', @UserName, '%') OR ISNULL(@UserName, '') = '' )
  ORDER BY a.RowId DESC;
END
GO

GRANT EXECUTE ON [report].[CaseAccessLog] TO [Administrator]
GO

GRANT EXECUTE ON [report].[CaseAccessLog] TO [Avdelingsleder]
GO

GRANT EXECUTE ON [report].[CaseAccessLog] TO [Leder]
GO

GRANT EXECUTE ON [report].[CaseAccessLog] TO [Support]
GO