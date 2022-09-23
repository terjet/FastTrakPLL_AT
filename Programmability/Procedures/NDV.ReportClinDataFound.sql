SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportClinDataFound]( @DiabetesType INT, @FirstDate DateTime = NULL, @LastDate DateTime = NULL ) AS
BEGIN

  -- Inclusion period
  IF @LastDate IS NULL SET @LastDate = DATEDIFF(DAY,0,GETDATE());
  IF @FirstDate IS NULL SET @FirstDate = DATEADD( month, -15, @LastDate );

  -- Collection periods for labdata is different from inclusion
  CREATE TABLE #Dates( ItemId INT NOT NULL PRIMARY KEY, Months INT, StartDate DateTime, Caption VARCHAR(32), UnknownVal INT, OrderNo INT );
  INSERT INTO #Dates VALUES (  3196, 120, @FirstDate, 'Diabetes type', -1, 1 );
  INSERT INTO #Dates VALUES (  3389, 120, @FirstDate, 'Samtykke besvart Ja/Nei/Trukket', 4, 2 );
  INSERT INTO #Dates VALUES (  3982, 120, @FirstDate, 'Etnisitet besvart', 5, 3 );
  INSERT INTO #Dates VALUES (  3342, 15, @FirstDate, 'Koronarsykdom i familien besvart', 3, 4 );
  -- Undersøkelser
  INSERT INTO #Dates VALUES (  3225, 120, @FirstDate, 'Høyde registrert', -1, 5 ); 
  INSERT INTO #Dates VALUES (  3224,  15, @FirstDate, 'Vekt registrert', -1, 6 ); 
  INSERT INTO #Dates VALUES (  3227, 15, @FirstDate, 'Røykevaner besvart', 4, 7 );
  INSERT INTO #Dates VALUES (  3230, 15, @FirstDate, 'Blodtrykk registrert', -1, 8 );
  INSERT INTO #Dates VALUES (  4636, 15, @FirstDate, 'Fotsensibilitet undersøkt', 5, 9 );
  INSERT INTO #Dates VALUES (  4637, 15, @FirstDate, 'Fotpuls undersøkt', 5, 10 );
  -- Medikamenter
  INSERT INTO #Dates VALUES (  3322, 15, @FirstDate, 'Behandlingsstrategi besvart', 5, 11 );
  INSERT INTO #Dates VALUES (  3336, 15, @FirstDate, 'Platehemmer besvart', 3, 12 );
  INSERT INTO #Dates VALUES (  4003, 15, @FirstDate, 'Antikoagulasjon besvart', 3, 12 );
  INSERT INTO #Dates VALUES (  3337, 15, @FirstDate, 'Lipidsenkende besvart', 3, 13 );
  INSERT INTO #Dates VALUES (  3339, 15, @FirstDate, 'ACE-hemmer besvart', 3, 14 );

  -- Get caselist for everybody with NDV_TYPE (ItemId=3196) in period
  SELECT DISTINCT ce.PersonId INTO #CaseList 
  FROM dbo.ClinEvent ce 
  JOIN dbo.StudyGroup sg ON sg.StudyId=ce.StudyId AND sg.GroupId=ce.GroupId AND sg.GroupActive=1
  JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId=USER_ID()
  JOIN dbo.ClinDatapoint dp ON dp.EventId=ce.EventId AND dp.ItemId=3196
  WHERE ( ce.EventTime >= @FirstDate ) AND ( ce.EventTime < @LastDate ) AND ( dp.EnumVal = @DiabetesType );

  -- Get denominator
  DECLARE @Antall INT;
  SELECT @Antall = COUNT(DISTINCT PersonId) FROM #CaseList;

  -- Count data registered
  SELECT v.PersonId,dp.ItemId,count(dp.RowId) as Antall
  INTO #PersonDataCount FROM #CaseList v
  JOIN dbo.ClinEvent ce ON ce.PersonId=v.PersonId
  JOIN dbo.ClinDatapoint dp ON dp.EventId=ce.EventId
  JOIN #Dates d ON d.ItemId=dp.ItemId
  WHERE ( ce.EventTime > d.StartDate ) AND ( ce.EventTime < @LastDate ) 
    AND (dp.Quantity > 0 ) AND ( ISNULL(dp.EnumVal,0) <> d.UnknownVal  )
  GROUP BY v.PersonId,dp.ItemId;

  -- Aggregate data
  SELECT ItemId,COUNT(*) as Teller
  INTO #FinalDataset
  FROM #PersonDataCount
  GROUP BY ItemId;
  -- Get Result
  SELECT mi.ItemId,d.Caption,d.StartDate,d.Months,@LastDate as StopDate,ISNULL(r.Teller,0) AS Teller,@Antall AS Nevner,
    CONVERT(DECIMAL(5,1),100*CONVERT(FLOAT,Teller)/CONVERT(FLOAT,@Antall),2) as Andel 
  FROM #Dates d
  JOIN dbo.MetaItem mi ON mi.ItemId=d.ItemId
  LEFT OUTER JOIN #FinalDataset r ON r.ItemId=d.ItemId
  ORDER BY d.OrderNo;
END
GO

GRANT EXECUTE ON [NDV].[ReportClinDataFound] TO [FastTrak]
GO