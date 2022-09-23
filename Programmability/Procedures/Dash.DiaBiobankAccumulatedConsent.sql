SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[DiaBiobankAccumulatedConsent] 
AS
BEGIN
	SELECT Report.PartitionKey(Dataset.CenterId) AS PartitionKey,
		   Report.RowKeyReverse(Dataset.TimeAxis) AS RowKey,
		   'WW' AS TimeResolution,
		   Dataset.*,
		   DataSource.*
	FROM (SELECT WeekList.StartTime AS TimeAxis, AggByCenter.CenterId, AggByCenter.n
		    FROM (
				SELECT StartTime
				  FROM Report.TimePeriods ml
			     WHERE PeriodType = 'WEEK'
			       AND StartTime > DATEADD(MM, -36, GETDATE())
			       AND StartTime < GETDATE()) WeekList
        CROSS APPLY 
        (
                SELECT pas.CenterId, COUNT(*) AS n
                        FROM (
                        SELECT PersonId, CenterId
                                FROM (
                                SELECT ce.PersonId, sg.CenterId, ROW_NUMBER() OVER (PARTITION BY ce.PersonId, sg.CenterId ORDER BY ce.EventNum) AS SortOrder
                                        FROM dbo.ClinDataPoint cdp 
                                                JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
                                                JOIN dbo.StudyGroup sg ON sg.StudyId = ce.StudyId AND sg.GroupId = ce.GroupId
                                        WHERE cdp.ItemId = 1502
                                        AND cdp.EnumVal = 1
                                        AND ce.EventTime < WeekList.StartTime) LastCenter
                                WHERE LastCenter.SortOrder = 1) pas
                GROUP BY pas.CenterId) AggByCenter) Dataset
    CROSS JOIN Report.DataSource() AS DataSource
    ORDER BY TimeAxis DESC;
END
GO

GRANT EXECUTE ON [Dash].[DiaBiobankAccumulatedConsent] TO [FastTrak]
GO