SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RapportAtferdTotals] ( @PersonId INT, @StartAt DATETIME, @StopAt DATETIME ) AS
BEGIN
    SELECT d,
        [1] AS Sleeping,
        [2] AS FeelingDown,
        [3] AS Restless,
        [4] AS Irritable,
        [5] AS Movement,
        [6] AS Hallucination,
        [7] AS Yelling,
        [8] AS ActionOut,
        [9] AS Calm,
        [-1] AS NoValue
    FROM (
        SELECT
			ce.EventTime AS et,
            CONVERT( DATE, ce.EventTime ) AS d,
            ISNULL(cdp.EnumVal, -1) AS EnumVal
        FROM dbo.ClinForm cf
        JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
        JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = 'GBD_ATFERD'
        JOIN dbo.MetaItem mi ON mi.ItemId BETWEEN 1630 AND 1653
        LEFT OUTER JOIN dbo.ClinDataPoint cdp ON cdp.ItemId = mi.ItemId AND cdp.EventId = cf.EventId
        WHERE ce.PersonId = @PersonId
        AND cf.FormStatus = 'L'
        AND ( ce.EventTime >= @StartAt AND ce.EventTime < @StopAt )
    ) t
    PIVOT (
        COUNT( t.EnumVal ) FOR t.EnumVal IN ( [1], [2], [3], [4], [5], [6], [7], [8], [9], [-1] ) 
    ) PivotTable
	ORDER BY PivotTable.et;
END
GO

GRANT EXECUTE ON [GBD].[RapportAtferdTotals] TO [FastTrak]
GO