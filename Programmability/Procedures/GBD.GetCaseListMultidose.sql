SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListMultidose] (@StudyId INT) AS
BEGIN
	SELECT v.PersonId, v.DOB, v.FullName, v.GenderId, v.GroupName, CONCAT('Antall multidosemedikamenter: ', t.Total) AS InfoText
	FROM (SELECT ot.PersonId, COUNT(ot.PackType) AS Total
		FROM dbo.OngoingTreatment ot
		WHERE ot.PackType = 'M'
		GROUP BY ot.PersonId) t
	JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = t.PersonId AND v.StudyId = @StudyId
	ORDER BY v.PersonId;
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListMultidose] TO [Farmasøyt]
GO

GRANT EXECUTE ON [GBD].[GetCaseListMultidose] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListMultidose] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[GetCaseListMultidose] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[GetCaseListMultidose] TO [Vernepleier]
GO