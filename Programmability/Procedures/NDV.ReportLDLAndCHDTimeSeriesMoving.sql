SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportLDLAndCHDTimeSeriesMoving] (@StartYear INT, @LDLCutoff FLOAT, @LookbackMonths INT) AS
BEGIN
  DECLARE @Type1Subpopulation TABLE (StartTime DATETIME,PersonId INT, LDLResult FLOAT);
  DECLARE @MonthList TABLE (StartTime DATETIME, StartNum INT);
  DECLARE @StartDate DATETIME;
  DECLARE @StopDate DATETIME;
  DECLARE @LastEventNum INT;
  DECLARE @ReportLengthMonths INT;

  SELECT @ReportLengthMonths = s.IntValue FROM Config.Setting s
  WHERE s.Section = 'NDV.ReportLDLAndCHDTimeSeriesMoving' AND s.KeyName = 'ReportLengthMonths'

  IF @ReportLengthMonths IS NULL
     -- Find start of the year passed in as a parameter.
    SELECT @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR, @StartYear) + '-01-01');
  ELSE
    SELECT @StartDate = DATEADD(MONTH, -@ReportLengthMonths, GETDATE());

  SET @StopDate = GETDATE();

  INSERT @MonthList
    SELECT StartTime, dbo.FnEventTimeToNum (ml.StartTime)
      FROM Report.TimePeriods ml
     WHERE PeriodType = 'MONTH' 
       AND StartTime >= @StartDate 
       AND StartTime <= @StopDate 
       AND StartTime < GETDATE()

  INSERT @Type1Subpopulation
    SELECT MonthList.StartTime, Patients.PersonId, Patients.NumResult
    FROM @MonthList MonthList
      CROSS APPLY (
        SELECT DISTINCT p.personID, lab.NumResult
          FROM NDV.GetRecentPatientsTable(1, MonthList.StartTime, @LookbackMonths) cas
             JOIN dbo.Person p ON p.PersonId = cas.PersonId
             JOIN dbo.GetLastLabDataTable(35, MonthList.StartTime) lab ON lab.PersonId = cas.PersonId
               JOIN (
               SELECT a.PersonId, a.EventTime, a.EnumVal, a.ItemId
                FROM (
                SELECT ce.PersonId, ce.EventTime, cdp.ItemId, cdp.EnumVal, ROW_NUMBER() OVER (PARTITION BY ce.PersonId, cdp.ItemId ORDER BY ce.EventTime DESC) AS ReverseOrder
                    FROM dbo.ClinEvent ce
                        JOIN dbo.ClinDataPoint cdp ON
                            cdp.EventId = ce.EventId
                        AND ce.EventNum < MonthList.StartNum
                        AND cdp.ItemId IN (3397, 3398, 3414, 3417)
                        AND (cdp.EnumVal IS NOT NULL AND cdp.EnumVal > -1)) a
                    WHERE a.ReverseOrder = 1
                      AND ((a.ItemId IN (3397, 3398, 3417) AND a.EnumVal = 1) OR (a.ItemId = 3414 AND a.EnumVal IN (2, 3)))
            ) a ON a.PersonId = p.PersonId) Patients
  SELECT SubPopAgg.StartTime AS MonthStart,
    SubPopAgg.NumPatients,
    ISNULL(BelowCutoffAgg.NumBelowCutoff, 0) AS NumBelowCutoff,
    100.0 * ISNULL(BelowCutoffAgg.NumBelowCutoff, 0) / SubPopAgg.NumPatients AS PctBelowCutoffTotal
  FROM (
    SELECT t1.StartTime, COUNT(*) AS NumPatients
      FROM @Type1Subpopulation t1
    GROUP BY t1.StartTime) SubPopAgg
  LEFT JOIN (SELECT t1.StartTime, COUNT(*) AS NumBelowCutoff
    FROM @Type1Subpopulation t1
    WHERE t1.LDLResult < @LDLCutoff
    GROUP BY t1.StartTime) BelowCutoffAgg ON BelowCutoffAgg.StartTime = SubPopAgg.StartTime
  WHERE SubPopAgg.NumPatients > 0
  ORDER BY SubPopAgg.StartTime;
END
GO

GRANT EXECUTE ON [NDV].[ReportLDLAndCHDTimeSeriesMoving] TO [FastTrak]
GO