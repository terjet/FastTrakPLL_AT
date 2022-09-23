SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportHbA1cTimeSeriesMoving]( @StartYear INT, @HbA1cCutoff FLOAT, @LookbackMonths INT, @LookForwardMonths INT )  AS
BEGIN

  DECLARE @StartDate DateTime;
  DECLARE @StopDate DateTime;
                    
  -- Merge labdata from ClinDatapoint to LabData
                                      
  EXEC NDV.MergeHba1cToLabdata;
                        
  -- Find start and end of the year passed in as a parameter.
    
  SELECT @StartDate = CONVERT(DateTime,CONVERT(VARCHAR, @StartYear) + '-01-01');
  SET @StopDate = DATEADD( MONTH, @LookforwardMonths, @StartDate );

  SELECT 
    MonthList.StartTime AS MonthStart, 
    AllType1.NumPatients, 
    AboveCutoffAgg.NumHbA1c AS NumAboveCutoff, 
    AboveCutoffAgg.MinHbA1c, 
    AboveCutoffAgg.AvgHbA1cAboveCutoff, 
    AboveCutoffAgg.MaxHbA1c, 
    100.0 * AboveCutoffAgg.NumHbA1c / AllType1.NumPatients AS PctAboveCutoffTotal
  FROM

  ( 
    SELECT StartTime FROM Report.TimePeriods ml 
    WHERE PeriodType = 'MONTH' AND StartTime >= @StartDate AND StartTime <= @StopDate AND StartTime < GETDATE()
  ) MonthList

CROSS APPLY 

  (
    SELECT COUNT(Type1AboveCutoff.NumResult) AS NumHbA1c, 
      MIN(Type1AboveCutoff.NumResult) AS MinHbA1c,
      MAX(Type1AboveCutoff.NumResult) AS MaxHbA1c,
      AVG(Type1AboveCutoff.NumResult) AS AvgHbA1cAboveCutoff
    FROM   
    (
      SELECT cas.PersonId,lab.NumResult  
      FROM NDV.GetRecentPatientsTable( 1, MonthList.StartTime, @LookbackMonths ) cas
      JOIN dbo.GetLastLabDataTable( 1058, MonthList.StartTime) lab ON lab.PersonId = cas.PersonId
      WHERE NumResult >= @HbA1cCutoff
    ) Type1AboveCutoff
  ) AboveCutoffAgg

CROSS APPLY 

  ( 
    SELECT COUNT(*) AS NumPatients FROM NDV.GetRecentPatientsTable( 1, MonthList.StartTime, @LookbackMonths )
  ) AllType1 
  WHERE AllType1.NumPatients > 0
  ORDER BY MonthStart;

END;
GO

GRANT EXECUTE ON [NDV].[ReportHbA1cTimeSeriesMoving] TO [FastTrak]
GO