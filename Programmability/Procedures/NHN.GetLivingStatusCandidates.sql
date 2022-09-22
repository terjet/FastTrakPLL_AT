SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NHN].[GetLivingStatusCandidates] (@DayInterval INT = 7, @MaxNoOfPatients INT = 10) AS
BEGIN
	SELECT TOP (@MaxNoOfPatients) NationalId
	FROM (SELECT DISTINCT p.NationalId
		FROM dbo.Person p
		WHERE NOT (NULLIF(p.NationalId, '') IS NULL)
		AND ISNULL(p.DeceasedInd, 0) = 0
		EXCEPT
		SELECT lsc.NationalId
		FROM dbo.LivingStatusCheck lsc
		WHERE lsc.LastChecked > DATEADD(DAY, -@DayInterval, GETDATE())) a;
END;
GO

GRANT EXECUTE ON [NHN].[GetLivingStatusCandidates] TO [ScheduledTask]
GO