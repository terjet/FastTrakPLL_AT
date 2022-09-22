SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[FixMissingGroupIds] (@StudyName VARCHAR(40), @Cutoff DATE) AS
BEGIN
	MERGE
	INTO dbo.ClinEvent a USING (SELECT GroupId, StatusId, EventId
		FROM (SELECT ce.EventId,
				ce.PersonId,
				CRF.GetGroupOnDate(ce.PersonId, @StudyName, ce.EventTime, 1) AS GroupId,
				CRF.GetStatusOnDate(ce.PersonId, @StudyName, ce.EventTime, 1) AS StatusId
			FROM dbo.ClinEvent ce
			JOIN dbo.Study s
				ON s.StudyId = ce.StudyId
				AND s.StudName = @StudyName
			WHERE ce.GroupId IS NULL
			AND ce.EventTime > @Cutoff) a
		WHERE NOT a.StatusId IS NULL
		AND NOT a.GroupId IS NULL) b
	ON a.EventId = b.EventId
	WHEN MATCHED
		THEN UPDATE
			SET a.GroupId = b.GroupId, a.StatusId = b.StatusId;
END;
GO

GRANT EXECUTE ON [Tools].[FixMissingGroupIds] TO [Administrator]
GO