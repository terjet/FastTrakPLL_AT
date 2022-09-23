SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportAverageNumberOfConsultationsHbA1c] AS
BEGIN
	DECLARE @ReferenceDay DATETIME = GETDATE();
	DECLARE @PrevYearFirstDay DATETIME = DATEADD(YEAR, DATEDIFF(YEAR, 0, @ReferenceDay) - 1, 0);
	DECLARE @PrevYearLastDay DATETIME = DATEADD(YEAR, DATEDIFF(YEAR, 0, @ReferenceDay), -1);
	DECLARE @TwoYearsAgoFirstDay DATETIME = DATEADD(YEAR, -1, @PrevYearFirstDay);
	DECLARE @TwoYearsAgoLastDay DATETIME = DATEADD(YEAR, -1, @PrevYearLastDay);

	DECLARE @Population TABLE (PersonId INT, CenterId INT, HbA1cCutOff FLOAT)
	DECLARE @Consultations TABLE (PersonId INT, InTwoYearsAgo INT, InYearAgo INT)
	DECLARE @LabDataHbA1c TABLE (PersonId INT, LabDate DATETIME, LabName VARCHAR(40), NumResult FLOAT)
	DECLARE @GroupBelow TABLE (CenterId INT, CenterName VARCHAR(40), PopulationCount INT, CountConsultationTwoYearsAgo INT, AvgConsultationsTwoYearsAgo FLOAT, CountConsultationYearAgo INT, AvgConsultationsYearAgo FLOAT, GroupHbA1c VARCHAR(5))
	DECLARE @GroupBelowTemp TABLE (CenterId INT, CenterName VARCHAR(40), PopulationCount INT, CountConsultationTwoYearsAgo INT, AvgConsultationsTwoYearsAgo FLOAT, CountConsultationYearAgo INT, AvgConsultationsYearAgo FLOAT, GroupHbA1c VARCHAR(5))
	DECLARE @GroupAboveTemp TABLE (CenterId INT, CenterName VARCHAR(40), PopulationCount INT, CountConsultationTwoYearsAgo INT, AvgConsultationsTwoYearsAgo FLOAT, CountConsultationYearAgo INT, AvgConsultationsYearAgo FLOAT, GroupHbA1c VARCHAR(5))
	DECLARE @GroupAbove TABLE (CenterId INT, CenterName VARCHAR(40), PopulationCount INT, CountConsultationTwoYearsAgo INT, AvgConsultationsTwoYearsAgo FLOAT, CountConsultationYearAgo INT, AvgConsultationsYearAgo FLOAT, GroupHbA1c VARCHAR(5))
	DECLARE @AllTemp TABLE (CenterId INT, CenterName VARCHAR(40), PopulationCount INT, CountConsultationTwoYearsAgo INT, AvgConsultationsTwoYearsAgo FLOAT, CountConsultationYearAgo INT, AvgConsultationsYearAgo FLOAT, GroupHbA1c VARCHAR(5))
    DECLARE @All TABLE (CenterId INT, CenterName VARCHAR(40), PopulationCount INT, CountConsultationTwoYearsAgo INT, AvgConsultationsTwoYearsAgo FLOAT, CountConsultationYearAgo INT, AvgConsultationsYearAgo FLOAT, GroupHbA1c VARCHAR(5))

    -- Last HbA1c per person before two years ago
    INSERT @LabDataHbA1c
    SELECT PersonId, LabDate, LabName, NumResult
    FROM (SELECT ld.PersonId, ld.LabDate, lc.LabName, ld.NumResult, RANK()
    OVER (
        PARTITION BY ld.PersonId
        ORDER BY ld.LabDate DESC, ResultId DESC ) AS OrderNo
        FROM dbo.LabData ld
        JOIN dbo.LabCode lc 
        ON lc.LabCodeId=ld.LabCodeId
        WHERE lc.LabClassId = 1058
        AND ld.LabDate < @TwoYearsAgoFirstDay
        AND ISNULL(ld.NumResult, -1) >= 0) a
    WHERE OrderNo = 1;

    -- Patient that had diabetes type 1 15 Months before
    INSERT @Population
    SELECT DISTINCT ce.PersonId, sg.CenterId, ld.NumResult HbA1cCutOff
    FROM dbo.ClinDataPoint cdp
    JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
    JOIN Study s ON s.StudyId = ce.StudyId AND s.StudName IN ('NDV', 'ENDO', 'Barnediabetes')
    JOIN dbo.StudyGroup sg ON sg.StudyId = ce.StudyId AND sg.GroupId = ce.GroupId
    JOIN dbo.MyStudyCenters msc ON sg.CenterId = msc.CenterId
    JOIN dbo.StudyCenter sc ON sc.CenterId = sg.CenterId
    JOIN dbo.GetLastEnumValuesTable(3196, NULL) LastDiabetesType ON ce.PersonId = LastDiabetesType.PersonId
    JOIN @LabDataHbA1c ld ON ld.PersonId = ce.PersonId
    WHERE cdp.ItemId = 3196 
    AND ce.EventTime > DATEADD( MONTH, -15, @TwoYearsAgoFirstDay ) AND ce.EventTime < @TwoYearsAgoFirstDay
    AND LastDiabetesType.EnumVal = 1 -- sjekk at sist registrerte diagnose er diabetes type 1
    AND sc.CenterActive = 1;

    INSERT @Consultations
    SELECT
        ISNULL(InTwoYearsAgo.PersonId, InYearAgo.PersonId),
        ISNULL(InTwoYearsAgo.n, 0),
        ISNULL(InYearAgo.n, 0) 
    FROM (
        SELECT PersonId, COUNT(*) AS n
        FROM ( 
                SELECT ce.PersonId, CONVERT(DATE, ce.EventTime) EventDate
                FROM ClinEvent ce 
                JOIN ClinDataPoint cdp ON cdp.EventId = ce.EventId AND cdp.ItemId = 3196
                WHERE ce.EventTime BETWEEN @TwoYearsAgoFirstDay AND @TwoYearsAgoLastDay
        ) sq
    GROUP BY PersonId
    ) InTwoYearsAgo
    FULL JOIN
    (
        SELECT PersonId, COUNT(*) AS n
        FROM (
                SELECT ce.PersonId, CONVERT(DATE, ce.EventTime) EventDate FROM ClinEvent ce 
                JOIN ClinDataPoint cdp ON cdp.EventId = ce.EventId AND cdp.ItemId = 3196
                WHERE ce.EventTime BETWEEN @PrevYearFirstDay AND @PrevYearLastDay
        ) sq
        GROUP BY PersonId
    ) InYearAgo
    ON InYearAgo.PersonId = InTwoYearsAgo.PersonId

    -- Statistikk for pasienter med HbA1c under 75 mmol/mol
    INSERT @GroupBelowTemp
    SELECT msc.CenterId, msc.CenterName, n, 
    sq.n2Y, ISNULL(sq.AvgConsultations2Y, 0),
    sq.n1Y, ISNULL(sq.AvgConsultations1Y, 0), 'below'
    FROM (
        SELECT
                Pop.CenterId,
                COUNT(*) AS n,
                SUM((CASE WHEN Consultations.InTwoYearsAgo > 0 THEN 1 ELSE 0 END)) AS n2Y,
                AVG(CONVERT(FLOAT, Consultations.InTwoYearsAgo)) AS AvgConsultations2Y,
                SUM((CASE WHEN Consultations.InYearAgo > 0 THEN 1 ELSE 0 END)) AS n1Y,
                AVG(CONVERT(FLOAT, Consultations.InYearAgo)) AS AvgConsultations1Y
        FROM @Population Pop
        JOIN @Consultations Consultations ON Consultations.PersonId = Pop.PersonId
        LEFT JOIN @LabDataHbA1c lab ON pop.PersonId = lab.PersonId
        WHERE lab.NumResult < 75
        GROUP BY Pop.CenterId
    ) sq
    JOIN MyStudyCenters msc ON msc.CenterId = sq.CenterId

    INSERT @GroupBelow
    SELECT * FROM @GroupBelowTemp
    UNION ALL
    SELECT NULL, 'Totalt', n,
    sq.n2Y, ISNULL(sq.AvgConsultations2Y, 0),
    sq.n1Y, ISNULL(sq.AvgConsultations1Y, 0), 'below'
    FROM (
        SELECT COUNT(*) AS n,
        SUM((CASE WHEN Consultations.InTwoYearsAgo > 0 THEN 1 ELSE 0 END)) AS n2Y, AVG(CONVERT(FLOAT, Consultations.InTwoYearsAgo)) AS AvgConsultations2Y,
        SUM((CASE WHEN Consultations.InYearAgo > 0 THEN 1 ELSE 0 END)) AS n1Y, AVG(CONVERT(FLOAT, Consultations.InYearAgo)) AS AvgConsultations1Y
        FROM @Population Pop
        JOIN @Consultations Consultations ON Consultations.PersonId = Pop.PersonId
        LEFT JOIN @LabDataHbA1c lab ON pop.PersonId = lab.PersonId
        WHERE lab.NumResult < 75
    ) sq

    -- Statistikk for pasienter med HbA1c over eller lik 75 mmol/mol
    INSERT @GroupAboveTemp
    SELECT msc.CenterId, msc.CenterName, n,
    sq.n2Y, ISNULL(sq.AvgConsultations2Y, 0),
    sq.n1Y, ISNULL(sq.AvgConsultations1Y, 0), 'above'
    FROM 
    (
        SELECT Pop.CenterId, COUNT(*) AS n,
        SUM((CASE WHEN Consultations.InTwoYearsAgo > 0 THEN 1 ELSE 0 END)) AS n2Y, AVG(CONVERT(FLOAT, Consultations.InTwoYearsAgo)) AS AvgConsultations2Y,
        SUM((CASE WHEN Consultations.InYearAgo > 0 THEN 1 ELSE 0 END)) AS n1Y, AVG(CONVERT(FLOAT, Consultations.InYearAgo)) AS AvgConsultations1Y
        FROM @Population Pop
        JOIN @Consultations Consultations ON Consultations.PersonId = Pop.PersonId
        LEFT JOIN @LabDataHbA1c lab ON pop.PersonId = lab.PersonId
        WHERE lab.NumResult >= 75
        GROUP BY Pop.CenterId
    ) sq
    JOIN MyStudyCenters msc ON msc.CenterId = sq.CenterId

    INSERT @GroupAbove
    SELECT * FROM @GroupAboveTemp
    UNION ALL
    SELECT NULL,
    'Totalt',
    n,
    sq.n2Y,
    ISNULL(sq.AvgConsultations2Y, 0),
    sq.n1Y,
    ISNULL(sq.AvgConsultations1Y, 0),
    'above'
    FROM (
        SELECT
                COUNT(*) AS n,
                SUM((CASE WHEN Consultations.InTwoYearsAgo > 0 THEN 1 ELSE 0 END)) AS n2Y,
                AVG(CONVERT(FLOAT, Consultations.InTwoYearsAgo)) AS AvgConsultations2Y,
                SUM((CASE WHEN Consultations.InYearAgo > 0 THEN 1 ELSE 0 END)) AS n1Y,
                AVG(CONVERT(FLOAT, Consultations.InYearAgo)) AS AvgConsultations1Y
        FROM @Population Pop
        JOIN @Consultations Consultations ON Consultations.PersonId = Pop.PersonId
        LEFT JOIN @LabDataHbA1c lab ON pop.PersonId = lab.PersonId
        WHERE lab.NumResult >= 75
    ) sq

    -- Statistikk for hele populasjonen uten hensyn til HbA1c-nivå 
    INSERT @AllTemp
    SELECT
        msc.CenterId,
        msc.CenterName,
        n,
        sq.n2Y,
        ISNULL(sq.AvgConsultations2Y, 0),
        sq.n1Y,
        ISNULL(sq.AvgConsultations1Y, 0),
        'all'
    FROM (
        SELECT Pop.CenterId, COUNT(*) AS n,
                SUM((CASE WHEN Consultations.InTwoYearsAgo > 0 THEN 1 ELSE 0 END)) AS n2Y, AVG(CONVERT(FLOAT, Consultations.InTwoYearsAgo)) AS AvgConsultations2Y,
                SUM((CASE WHEN Consultations.InYearAgo > 0 THEN 1 ELSE 0 END)) AS n1Y, AVG(CONVERT(FLOAT, Consultations.InYearAgo)) AS AvgConsultations1Y
        FROM @Population Pop
        JOIN @Consultations Consultations ON Consultations.PersonId = Pop.PersonId
        GROUP BY Pop.CenterId
    ) sq
    JOIN MyStudyCenters msc ON msc.CenterId = sq.CenterId

    INSERT @All
    SELECT * FROM @AllTemp
    UNION ALL
    SELECT NULL, 'Totalt', n,
    sq.n2Y, ISNULL(sq.AvgConsultations2Y, 0),
    sq.n1Y, ISNULL(sq.AvgConsultations1Y, 0), 'all'
    FROM (
        SELECT COUNT(*) AS n,
        SUM((CASE WHEN Consultations.InTwoYearsAgo > 0 THEN 1 ELSE 0 END)) AS n2Y, AVG(CONVERT(FLOAT, Consultations.InTwoYearsAgo)) AS AvgConsultations2Y,
        SUM((CASE WHEN Consultations.InYearAgo > 0 THEN 1 ELSE 0 END)) AS n1Y, AVG(CONVERT(FLOAT, Consultations.InYearAgo)) AS AvgConsultations1Y
        FROM @Population Pop
        JOIN @Consultations Consultations ON Consultations.PersonId = Pop.PersonId
    ) sq

    SELECT * FROM @GroupBelow 
    UNION ALL
    SELECT * FROM @GroupAbove
    UNION ALL
    SELECT * FROM @All
END;
GO

GRANT EXECUTE ON [NDV].[ReportAverageNumberOfConsultationsHbA1c] TO [FastTrak]
GO