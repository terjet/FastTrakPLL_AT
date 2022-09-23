SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportLDLNonCHDTimeSeriesMoving]( @StartYear INT, @LDLCutoff FLOAT, @LookbackMonths INT,
  @Treated BIT, @MinAge INT, @MaxAge INT ) AS
BEGIN

  DECLARE @Type1Subpopulation TABLE (StartTime DATETIME, PersonId INT, LDLResult FLOAT);
  DECLARE @MonthList TABLE (StartTime DATETIME, StartNum INT, FirstDOB Date, LastDOB DATE);
  DECLARE @StartDate DATETIME;
  DECLARE @StopDate DATETIME;
  DECLARE @LastEventNum INT;
  DECLARE @ReportLengthMonths INT;

  SELECT @ReportLengthMonths = s.IntValue FROM Config.Setting s
  WHERE s.Section = 'NDV.ReportLDLNonCHDTimeSeriesMoving' AND s.KeyName = 'ReportLengthMonths'

  IF @ReportLengthMonths IS NULL
     -- Find start of the year passed in as a parameter.
    SELECT @StartDate = CONVERT(DATETIME, CONVERT(VARCHAR, @StartYear) + '-01-01');
  ELSE
    SELECT @StartDate = DATEADD(MONTH, -@ReportLengthMonths, GETDATE());

  SET @StopDate = GETDATE();

  INSERT @MonthList
    SELECT StartTime, dbo.FnEventTimeToNum (ml.StartTime),
      DATEADD( YY, -@MaxAge, StartTime ) AS FirstDOB, 
      DATEADD( YY, -@MinAge, StartTime ) AS LastDOB
    FROM Report.TimePeriods ml
    WHERE PeriodType = 'MONTH'
      AND StartTime >= @StartDate 
      AND StartTime <= @StopDate 
      AND StartTime < GETDATE()

  SELECT MonthList.StartNum, cas.PersonId, cas.NumResult AS LDLResult INTO #RecentType1WithLabData 
  FROM @MonthList MonthList 
  CROSS APPLY 
  (
    SELECT cas.personID, lab.NumResult 
    FROM NDV.GetRecentPatientsTable(1, MonthList.StartTime, @LookbackMonths) cas
    JOIN dbo.GetLastLabDataTable(35, MonthList.StartTime) lab ON lab.PersonId = cas.PersonId
  ) cas

  CREATE INDEX IT_RecentType1WithLabData_PersonId ON #RecentType1WithLabData (PersonId);

  SELECT ce.PersonId, cdp.ItemId, ce.eventTime, dbo.FnEventTimeToNum (DATEADD(DAY, 1, EOMONTH(ce.eventTime))) AS MonthVal, cdp.EnumVal
  INTO #EnumData
  FROM #RecentType1WithLabData recentType1
  JOIN dbo.ClinEvent ce ON ce.PersonId = recentType1.PersonId
  JOIN dbo.ClinDataPoint cdp
    ON cdp.EventId = ce.EventId
  WHERE cdp.ItemId IN (3337, 3397, 3398, 3414, 3417) AND cdp.EnumVal > -1;   

  CREATE INDEX IT_EnumData_PersonId_ItemId ON #EnumData ( PersonId, ItemId );

  -- Monthly overview of patients' cardiovascular disease status
  SELECT recentType1.PersonId, recentType1.StartNum AS MonthVal,
    CASE
      WHEN WithCVDMonthly.PersonId IS NULL THEN 0
      ELSE 1
    END AS CVD 
    INTO #CVDPatientMonthly FROM #RecentType1WithLabData recentType1 
  LEFT JOIN (
    SELECT MonthList.StartNum, WithCVD.PersonId
    FROM @MonthList MonthList
      CROSS APPLY (
        SELECT a.PersonId
          FROM (    
            SELECT recentType1.PersonId, enum.ItemId, enum.eventTime, enum.MonthVal, enum.EnumVal, ROW_NUMBER()
                OVER (
                PARTITION BY recentType1.PersonId, enum.ItemId
                ORDER BY enum.EventTime DESC) AS ReverseOrder
              FROM #RecentType1WithLabData recentType1
              LEFT JOIN #EnumData enum ON enum.PersonId = recentType1.PersonId AND enum.MonthVal <= MonthList.StartNum
              WHERE recentType1.StartNum = MonthList.StartNum 
            ) a
          WHERE a.ReverseOrder = 1 AND (a.ItemId IN (3397, 3398, 3417, 3414))
           AND ((a.ItemId IN (3397, 3398, 3417) AND a.EnumVal = 1) OR  (a.ItemId = 3414 AND a.EnumVal IN (2, 3))) 
          GROUP BY a.PersonId
          ) WithCVD
  ) WithCVDMonthly ON WithCVDMonthly.PersonId = recentType1.PersonId AND WithCVDMonthly.StartNum = recentType1.StartNum

  -- Monthly overview of patients' lipid treatment status
  SELECT recentType1.PersonId, recentType1.StartNum AS MonthVal, HasEnumValMonthly.EnumVal AS TreatedEnumVal
  INTO #PatientLipidTreatmentMonthly
  FROM #RecentType1WithLabData recentType1 
  LEFT JOIN (    
    SELECT MonthList.StartNum, HasEnumVal.PersonId, HasEnumVal.EnumVal FROM @MonthList MonthList
      CROSS APPLY (
        SELECT a.PersonId, a.EnumVal
          FROM (    
            SELECT recentType1.PersonId, enum.ItemId, enum.eventTime, MonthVal, enum.EnumVal, ROW_NUMBER()
                OVER (
                PARTITION BY enum.PersonId, enum.ItemId
                ORDER BY enum.EventTime DESC) AS ReverseOrder
              FROM #RecentType1WithLabData recentType1
              JOIN #EnumData enum ON enum.PersonId = recentType1.PersonId AND enum.MonthVal <= MonthList.StartNum AND enum.ItemId = 3337
              WHERE recentType1.StartNum = MonthList.StartNum   
            ) a
          WHERE a.ReverseOrder = 1
          ) HasEnumVal
    ) HasEnumValMonthly ON HasEnumValMonthly.PersonId = recentType1.PersonId AND HasEnumValMonthly.StartNum = recentType1.StartNum

  INSERT @Type1Subpopulation
    SELECT MonthList.StartTime, Patients.PersonId, Patients.LDLResult
    FROM @MonthList MonthList
      CROSS APPLY (
        SELECT DISTINCT p.personID, recentType1.LDLResult
          FROM #RecentType1WithLabData recentType1
        JOIN dbo.Person p ON p.PersonId = recentType1.PersonId
        JOIN #PatientLipidTreatmentMonthly lipidTreatment ON lipidTreatment.PersonId = recentType1.PersonId AND lipidTreatment.MonthVal = MonthList.StartNum
        JOIN #CVDPatientMonthly CVD ON CVD.PersonId = recentType1.PersonId AND CVD.MonthVal = MonthList.StartNum
        WHERE recentType1.StartNum = MonthList.StartNum AND CVD.CVD = 0
            AND p.DOB >= MonthList.FirstDOB AND p.DOB < MonthList.LastDOB AND 
          ( 
            ( @Treated = 1 AND lipidTreatment.TreatedEnumVal = 1 ) OR
            ( @Treated = 0 AND ( lipidTreatment.TreatedEnumVal != 1 OR lipidTreatment.TreatedEnumVal IS NULL ) ) 
          )
      ) Patients

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
    WHERE t1.LDLResult <= @LDLCutoff
    GROUP BY t1.StartTime) BelowCutoffAgg ON BelowCutoffAgg.StartTime = SubPopAgg.StartTime
  WHERE SubPopAgg.NumPatients > 0
  ORDER BY SubPopAgg.StartTime;  
  
END
GO

GRANT EXECUTE ON [NDV].[ReportLDLNonCHDTimeSeriesMoving] TO [FastTrak]
GO