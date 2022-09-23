SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Dash].[NdvMedianInPeriod] (@ItemId INT, @DiabetesType INT, @LookBehindMonths INT,  @MinPatientCount INT) AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @CurrStartTime DATETIME;
  DECLARE @NumPatients INT;
  DECLARE @QuantityTable dbo.QuantityTableType; 

  CREATE TABLE #Dataset
  (
    TimeAxis DATE,
    Median DECIMAL(12,4),
    NumPatients INT
  );

  CREATE TABLE #RecentStablePatientsTable ( PersonId INT NOT NULL PRIMARY KEY );

  SELECT MonthList.StartTime 
  INTO #MonthList
  FROM 
  (
    SELECT StartTime
    FROM Report.TimePeriods ml
    WHERE PeriodType = 'MONTH'
    AND StartTime > DATEADD(YY, -5, GETDATE())
    AND StartTime < GETDATE()
  ) MonthList;

  DECLARE MonthCursor CURSOR FOR   
  SELECT StartTime
  FROM #MonthList; 
  
  -- Bruk markør/cursor for å gjennom kvar månad og kalla medianfunksjonen, sidan denne ikkje kan brukast med CROSS APPLY.

  OPEN MonthCursor;
  
  FETCH NEXT FROM MonthCursor   
  INTO @CurrStartTime;
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN
    INSERT INTO #RecentStablePatientsTable
    SELECT cas.PersonId
    FROM NDV.GetRecentPatientsTable(1, @CurrStartTime, @LookBehindMonths) cas;

    INSERT INTO @QuantityTable
    SELECT cas.PersonId, quantity.EventTime, quantity.Quantity
    FROM #RecentStablePatientsTable cas
    JOIN dbo.GetLastQuantityTable( @ItemId, @CurrStartTime) quantity ON quantity.PersonId = cas.PersonId;

    SELECT @NumPatients = COUNT(*) FROM #RecentStablePatientsTable cas
    JOIN dbo.GetLastQuantityTable( @ItemId, @CurrStartTime) quantity ON quantity.PersonId = cas.PersonId;

    INSERT INTO #Dataset (TimeAxis, Median, NumPatients)
    VALUES (@CurrStartTime, dbo.CalculateMedian(@QuantityTable), @NumPatients);

    DELETE FROM @QuantityTable;
    TRUNCATE TABLE #RecentStablePatientsTable;

    FETCH NEXT FROM MonthCursor   
    INTO @CurrStartTime;

  END;

  CLOSE MonthCursor;  
  DEALLOCATE MonthCursor;

  SELECT Report.PartitionKey(ul.CenterId) AS PartitionKey,
    Report.RowKeyReverse(Dataset.TimeAxis) AS RowKey,
    'MM' AS TimeResolution,
    Dataset.*,
    DataSource.*
  FROM #Dataset Dataset
  CROSS JOIN Report.DataSource() AS DataSource
  JOIN dbo.UserList ul ON ul.UserId = USER_ID()
  WHERE Dataset.NumPatients > @MinPatientCount
  ORDER BY TimeAxis DESC;  

END
GO

GRANT EXECUTE ON [Dash].[NdvMedianInPeriod] TO [FastTrak]
GO