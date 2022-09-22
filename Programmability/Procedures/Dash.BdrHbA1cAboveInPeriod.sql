SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[BdrHbA1cAboveInPeriod] (@HbA1cCutoff NUMERIC, @ConsultationLookback INT, @DiagnosisPeriodLookback INT, @MinPatientCount INT) AS
BEGIN
	 SELECT	Report.PartitionKey(ul.CenterId) AS PartitionKey, 
			Report.RowKeyReverse(Dataset.TimeAxis) AS RowKey, 
			'MM' AS TimeResolution, 
			Dataset.*, 
			DataSource.*
	  FROM	(
				 SELECT	MonthList.StartTime AS TimeAxis, 
						StablePatients.NumPatients, 
						AboveCutoffAgg.NumHbA1c AS NumAboveCutoff, 
						AboveCutoffAgg.MinHbA1c, 
						AboveCutoffAgg.AvgHbA1cAboveCutoff, 
						AboveCutoffAgg.MaxHbA1c, 
						100.0 * AboveCutoffAgg.NumHbA1c / StablePatients.NumPatients AS PctAboveCutoffTotal
				   FROM (
							 SELECT	StartTime
							   FROM Report.TimePeriods ml
							  WHERE PeriodType = 'MONTH'
								AND StartTime > DATEADD(YY, -5, GETDATE())
								AND StartTime < GETDATE()
						) MonthList
				CROSS APPLY (
					SELECT	COUNT(AboveCutoff.NumResult) AS NumHbA1c, 
							MIN(AboveCutoff.NumResult) AS MinHbA1c, 
							MAX(AboveCutoff.NumResult) AS MaxHbA1c, 
							AVG(AboveCutoff.NumResult) AS AvgHbA1cAboveCutoff
					  FROM (
								SELECT cas.PersonId, lab.NumResult
								  FROM BDR.GetRecentStablePatientsTable(MonthList.StartTime, @ConsultationLookback, @DiagnosisPeriodLookback) cas
									   JOIN dbo.GetLastLabDataTable(1058, MonthList.StartTime) lab ON lab.PersonId = cas.PersonId
								 WHERE lab.NumResult >=  @HbA1cCutoff
							) AboveCutoff
				) AboveCutoffAgg
				CROSS APPLY (
					SELECT COUNT(*) AS NumPatients
					  FROM BDR.GetRecentStablePatientsTable(MonthList.StartTime, @ConsultationLookback, @DiagnosisPeriodLookback)
				) StablePatients
				WHERE StablePatients.NumPatients > @MinPatientCount
			) Dataset
	CROSS JOIN Report.DataSource() AS DataSource
	JOIN dbo.UserList ul ON ul.UserId = USER_ID()
	ORDER BY TimeAxis DESC;
END;
GO