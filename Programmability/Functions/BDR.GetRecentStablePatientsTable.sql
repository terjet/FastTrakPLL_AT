SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [BDR].[GetRecentStablePatientsTable] (@CutoffDate DATETIME, @ConsultationLookBehindMonths INT, @DiagnosisPeriod INT)
RETURNS @PersonList TABLE (
	PersonId INT NOT NULL PRIMARY KEY
) AS
BEGIN
	INSERT INTO @PersonList
		SELECT DISTINCT ce1.PersonId
		  FROM dbo.ClinDataPoint cdp1
			   JOIN dbo.ClinEvent ce1 ON ce1.EventId = cdp1.EventId
			   JOIN dbo.StudyGroup sg ON sg.StudyId = ce1.StudyId AND sg.GroupId = ce1.GroupId AND sg.GroupActive = 1
			   JOIN dbo.UserList ul ON ul.UserId = USER_ID() AND ul.CenterId = sg.CenterId
			   JOIN dbo.ClinEvent ce2 ON ce2.StudyId = ce1.StudyId AND ce2.PersonId = ce1.PersonId AND ce2.GroupId = sg.GroupId
			   JOIN dbo.ClinDataPoint cdp2 ON cdp2.EventId = ce2.EventId
		 WHERE cdp1.ItemId = 3196 
		   AND ce1.EventTime BETWEEN DATEADD(MONTH, -@ConsultationLookBehindMonths , @CutoffDate) AND @CutoffDate
		   AND cdp2.ItemId = 3323 AND cdp2.DTVal < DATEADD(MONTH, -@DiagnosisPeriod, ce1.EventTime)
		ORDER BY ce1.PersonId;
	RETURN;
END
GO