SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetUsersLogins] ( @StudyId INT, @CenterId INT = NULL, @GroupId INT = NULL, @StartAt DATETIME = NULL, @EndAt DATETIME = NULL, @DeactivatedOnly TINYINT = 0 ) AS
BEGIN
	SELECT
		ul.UserId,
		ul.UserName,
		CAST( ISNULL( ul.IsActive, 1 ) AS BIT ) AS IsActive,
		t.SignedRow,
		t.ServTime,
		sg.GroupName,
		sc.CenterName,
		P.ReverseName
	FROM dbo.UserList ul
	JOIN sys.sysusers syu ON syu.uid = ul.UserId
	LEFT JOIN ( SELECT ServTime, UserId, ROW_NUMBER() OVER ( PARTITION BY UserId ORDER BY ServTime DESC ) SignedRow FROM dbo.UserLog ) t ON t.UserId = ul.UserId AND t.SignedRow = 1
	LEFT JOIN dbo.StudyCenter sc ON sc.CenterId = ul.CenterId
	LEFT JOIN dbo.Person p ON p.PersonId = ul.PersonId
	LEFT JOIN dbo.StudyUser su ON su.UserId = ul.UserId AND su.StudyId = @StudyId
	LEFT JOIN dbo.StudyGroup sg ON sg.GroupId = su.GroupId AND sg.StudyId = @StudyId
	WHERE ( t.ServTime >= @StartAt OR @StartAt IS NULL )
	AND ( t.ServTime <= @EndAt OR @EndAt IS NULL )
	AND ( ul.CenterId = @CenterId OR @CenterId IS NULL )
	AND ( su.GroupId = @GroupId OR @GroupId IS NULL )
	AND ( ( ISNULL( ul.IsActive, 1 ) = 1 AND @DeactivatedOnly = 0 )
		OR ( ISNULL( ul.IsActive, 1 ) = 0 AND @DeactivatedOnly = 1 ) )
    AND ( NOT syu.name IN ('dbo', 'sys', 'guest') )
	ORDER BY ul.UserId;
END;
GO