SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListProBNPgt1522Untreated]( @StudyId INT ) AS
BEGIN
    SELECT v.*, a.LabDate, a.NumResult, a.ResultId,
        'ProBNP = ' + CONVERT(VARCHAR, a.NumResult) + ' den ' + CONVERT(VARCHAR, a.LabDate, 104) + '.' AS InfoText
    FROM (SELECT PersonId, LabDate, NumResult, ResultId, RANK() OVER (PARTITION BY PersonId ORDER BY LabDate DESC) AS OrderNo
        FROM dbo.LabData ld
        JOIN dbo.LabCode lc
                ON lc.LabCodeId = ld.LabCodeId
        WHERE lc.LabClassId = 575) a
    JOIN dbo.ViewActiveCaseListStub v ON v.StudyId = @StudyId AND v.PersonId = a.PersonId
    WHERE a.OrderNo = 1 AND a.NumResult > 1522
    AND NOT v.PersonId IN (SELECT PersonId
        FROM dbo.OngoingTreatment ot
        WHERE ot.ATC LIKE 'C09%')
    ORDER BY a.NumResult DESC;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListProBNPgt1522Untreated] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProBNPgt1522Untreated] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProBNPgt1522Untreated] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListProBNPgt1522Untreated] TO [Vernepleier]
GO