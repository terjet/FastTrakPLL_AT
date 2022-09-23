SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListAntiHTLowBP] (@StudyId INT) AS
BEGIN
	SET NOCOUNT ON;
	SELECT DISTINCT a.PersonId, a.DOB, a.FullName, a.GroupName, 'Sys BT = ' + CONVERT(VARCHAR, CONVERT(INT, a.Quantity)) + ', ' + dt.DrugName AS InfoText
	FROM (SELECT ce.PersonId, vacls.DOB, vacls.FullName, vacls.GroupName, cdp.Quantity, vacls.StudyId, RANK() OVER (PARTITION BY ce.PersonId, ce.StudyId ORDER BY ce.EventTime DESC) AS rnk
		FROM dbo.ClinEvent ce
		JOIN dbo.ViewActiveCaseListStub vacls
			ON vacls.PersonId = ce.PersonId
		JOIN dbo.ClinDataPoint cdp
			ON cdp.EventId = ce.EventId AND cdp.ItemId = 3556) a
	JOIN dbo.DrugTreatment dt ON dt.PersonId = a.PersonId AND (dt.ATC LIKE 'C07%' OR dt.ATC LIKE 'C09%' OR dt.ATC LIKE 'C08%' OR dt.ATC LIKE 'C02%' OR dt.ATC LIKE 'C03%') AND (dt.StopAt IS NULL OR dt.StopAt > GETDATE())
	WHERE a.rnk = 1 AND a.Quantity < 120 AND a.StudyId = @StudyId
	ORDER BY FullName
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListAntiHTLowBP] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAntiHTLowBP] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAntiHTLowBP] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListAntiHTLowBP] TO [Vernepleier]
GO