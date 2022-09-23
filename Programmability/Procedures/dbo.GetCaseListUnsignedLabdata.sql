SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListUnsignedLabdata]( @StudyId INT ) AS
BEGIN
    SELECT v.*, FORMAT( unsigned.Antall, 'Har # usignerte prøvesvar') AS InfoText
    FROM dbo.ViewActiveCaseListStub v
    JOIN (
        SELECT PersonId, COUNT(*) AS Antall
        FROM dbo.LabData
        WHERE SignedBy IS NULL
        GROUP BY PersonId
    ) unsigned ON unsigned.PersonId = v.PersonId
	WHERE v.StudyId = @StudyId
    ORDER BY unsigned.Antall DESC, v.FullName;
END;
GO

GRANT EXECUTE ON [dbo].[GetCaseListUnsignedLabdata] TO [FastTrak]
GO