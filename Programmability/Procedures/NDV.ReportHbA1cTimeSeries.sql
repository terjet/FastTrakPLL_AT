SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportHbA1cTimeSeries]( @Year INT, @HbA1cCutoff FLOAT, @LookBehindMonths INT, @LookforwardMonths INT ) AS
BEGIN

  DECLARE @NumPatientsType1 INT;
  DECLARE @YearStart DateTime;
  DECLARE @YearEnd DateTime;

  -- Find start and end of the year passed in as a parameter.

  SELECT @YearStart = CONVERT(DateTime,CONVERT(VARCHAR, @Year) + '-01-01');
  SELECT @YearEnd = CONVERT(DateTime,CONVERT(VARCHAR,@Year+1) + '-01-01');

  -- Find Type-1 patients at the beginning of the year, looking back some months for data

  SELECT * INTO #Selection 
  FROM NDV.GetRecentPatientsTable( 1, @YearStart, @LookBehindMonths );

  -- Count them.

  SELECT @NumPatientsType1 = COUNT(*) FROM #Selection;

  -- Now get status for every month in the period

  SELECT 
    months.StartTime AS MonthStart, 
    @NumPatientsType1 AS NumPatients, 
	labs.NumAboveCutoff,
	labs.MinHbA1c,
	labs.MaxHbA1c,
	labs.AvgHbA1cAboveCutoff,
    100.0 * NumAboveCutoff / @NumPatientsType1 AS PercentAboveCutoff, 
	labs.AvgLabDate,
	DATEDIFF(dd,AvgLabDate,months.StartTime) AS LabAge
  FROM 

  ( 
    SELECT StartTime FROM Report.TimePeriods 
	WHERE PeriodType = 'MONTH' AND StartTime >= @YearStart AND StartTime <= DATEADD(MONTH,@LookforwardMonths,@YearStart) AND StartTime <= GETDATE()
  ) months

  CROSS APPLY
  (
    SELECT 
	  COUNT(NumResult) AS NumAboveCutoff,
	  CONVERT(DateTime,AVG(CONVERT(INT,lab.LabDate))) AS AvgLabDate,
	  MIN(NumResult) AS MinHbA1c, 
	  MAX(NumResult) AS MaxHbA1c, 
	  AVG(NumResult) AS AvgHbA1cAboveCutoff
	FROM #Selection cas
    JOIN dbo.GetLastLabDataTable( 45, months.StartTime ) lab ON lab.PersonId = cas.PersonId
    WHERE NumResult >= @HbA1cCutoff
  ) labs
  WHERE @NumPatientsType1 > 0;
  
END
GO

GRANT EXECUTE ON [NDV].[ReportHbA1cTimeSeries] TO [FastTrak]
GO