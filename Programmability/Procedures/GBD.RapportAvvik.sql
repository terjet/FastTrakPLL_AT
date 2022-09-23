SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RapportAvvik] ( @StudyId INT, @StartAt DateTime = NULL, @StopAt DateTime = NULL, @OrderBy INT = 0 ) AS
BEGIN
  SET LANGUAGE Norwegian;                     
  DECLARE @StartEventNum INT;
  DECLARE @StopEventNum INT;
  
  IF @StartAt IS NULL SET @StartAt = GETDATE() - 365;
  IF @StopAt IS NULL SET @StopAt = GETDATE();
  
  /* Calculate EventNums, because EventNum is indexed while EventTime is not */
  
  SET @StartEventNum = dbo.FnEventTimeToNum( @StartAt );
  SET @StopEventNum = dbo.FnEventTimeToNum( @StopAt );
  
  /* Select data into temporary table */
  
  SELECT 
    sc.PersonId, sg.CenterId, sg.GroupId, sg.GroupName, 
    ce.EventId, ce.EventTime, 
    cf.ClinFormId, cf.FormStatus, cf.FormComplete, cf.Comment,
    dbo.MonthYear( ce.EventTime ) AS MonthYear,
    DATENAME( mm, ce.EventTime ) AS MonthName,
    DATEPART( hh, ce.EventTime ) AS EventHour,
    DATEPART( ISO_WEEK, ce.EventTime ) AS EventWeek,
    v6402.EnumVal AS E6402,
    a6402.OptionText AS T6402,
    CONVERT(VARCHAR(16),v6410.TextVal) AS T6410,
    v8507.EnumVal AS E8507,
    a8507.OptionText AS T8507,
    v8508.EnumVal AS E8508,
    a8508.OptionText AS T8508,
    v8509.EnumVal AS E8509,
    a8509.OptionText AS T8509,
    v8510.EnumVal AS E8510,
    a8510.OptionText AS T8510,
    v8511.EnumVal AS E8511,
    a8511.OptionText AS T8511,
    v8512.EnumVal AS E8512,
    a8512.OptionText AS T8512,
    CONVERT(VARCHAR(16),v8513.TextVal) AS T8513,
    v8514.EnumVal AS E8514,
    a8514.OptionText AS T8514,
    CONVERT(VARCHAR(128),v8518.TextVal) AS T8518,
    CONVERT(VARCHAR(16),v8519.TextVal) AS T8519,
    v9105.EnumVal AS E9105,
    a9105.OptionText AS T9105,
    cf.CreatedAt, cf.CreatedBy, 
    pcr.Signature AS CreatedBySign, pcr.FullName AS CreatedByName, 
    ROW_NUMBER() OVER ( PARTITION BY ce.PersonId ORDER BY EventTime DESC ) AS OrderNo 
  INTO #temp
  FROM dbo.ClinForm cf
  JOIN dbo.ClinEvent ce ON ( ce.EventId = cf.EventId ) AND ( ce.StudyId = @StudyId )
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId 
  JOIN dbo.StudCase sc ON ( sc.StudyId = ce.StudyId ) AND ( sc.PersonId = ce.PersonId ) 
  JOIN dbo.StudyGroup sg ON ( sg.StudyId = ce.StudyId ) AND ( sg.GroupId = ce.GroupId ) 
  JOIN dbo.UserList my ON ( my.UserId = USER_ID() ) 
  JOIN dbo.StudyCenter c ON ( c.CenterId = sg.CenterId ) 
  JOIN dbo.UserList ucr ON ucr.UserId = cf.CreatedBy
  LEFT JOIN dbo.StudyUser su ON ( su.StudyId = sg.StudyId ) AND ( su.UserId = USER_ID() ) 
  LEFT JOIN dbo.Person pcr ON pcr.PersonId = ucr.PersonId 
    LEFT JOIN dbo.ClinDataPoint v6402 ON v6402.EventId=ce.EventId and v6402.ItemId = 6402
      LEFT JOIN dbo.MetaItemAnswer a6402 ON a6402.ItemId=6402 and v6402.EnumVal = a6402.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v6410 ON v6410.EventId=ce.EventId and v6410.ItemId = 6410
    LEFT JOIN dbo.ClinDataPoint v8507 ON v8507.EventId=ce.EventId and v8507.ItemId = 8507
      LEFT JOIN dbo.MetaItemAnswer a8507 ON a8507.ItemId=8507 and v8507.EnumVal = a8507.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v8508 ON v8508.EventId=ce.EventId and v8508.ItemId = 8508
      LEFT JOIN dbo.MetaItemAnswer a8508 ON a8508.ItemId=8508 and v8508.EnumVal = a8508.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v8509 ON v8509.EventId=ce.EventId and v8509.ItemId = 8509
      LEFT JOIN dbo.MetaItemAnswer a8509 ON a8509.ItemId=8509 and v8509.EnumVal = a8509.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v8510 ON v8510.EventId=ce.EventId and v8510.ItemId = 8510
      LEFT JOIN dbo.MetaItemAnswer a8510 ON a8510.ItemId=8510 and v8510.EnumVal = a8510.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v8511 ON v8511.EventId=ce.EventId and v8511.ItemId = 8511
      LEFT JOIN dbo.MetaItemAnswer a8511 ON a8511.ItemId=8511 and v8511.EnumVal = a8511.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v8512 ON v8512.EventId=ce.EventId and v8512.ItemId = 8512
      LEFT JOIN dbo.MetaItemAnswer a8512 ON a8512.ItemId=8512 and v8512.EnumVal = a8512.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v8513 ON v8513.EventId=ce.EventId and v8513.ItemId = 8513
    LEFT JOIN dbo.ClinDataPoint v8514 ON v8514.EventId=ce.EventId and v8514.ItemId = 8514
      LEFT JOIN dbo.MetaItemAnswer a8514 ON a8514.ItemId=8514 and v8514.EnumVal = a8514.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v8518 ON v8518.EventId=ce.EventId and v8518.ItemId = 8518
    LEFT JOIN dbo.ClinDataPoint v8519 ON v8519.EventId=ce.EventId and v8519.ItemId = 8519
    LEFT JOIN dbo.ClinDataPoint v9105 ON v9105.EventId=ce.EventId and v9105.ItemId = 9105
      LEFT OUTER JOIN dbo.MetaItemAnswer a9105 ON a9105.ItemId=9105 and v9105.EnumVal = a9105.OrderNumber
  WHERE ( cf.DeletedAt IS NULL )
    AND ( mf.FormName = 'GbdAvvik' )
    AND ( ( su.GroupId = sg.GroupId ) OR ( ISNULL( su.ShowMyGroup, 0 ) = 0 ) ) 
    AND ( sg.CenterId = my.CenterId ) 
    AND ( sc.StudyId = @StudyId ) 
    AND ( ce.EventNum >= @StartEventNum ) AND ( ce.EventNum < @StopEventNum );
    
  /* Select final dataset from temp table */
  
  IF @OrderBy=0 
    SELECT * FROM #temp ORDER BY EventTime;
  IF @OrderBy=1 
    SELECT * FROM #temp ORDER BY E8514, T8507;
  IF @OrderBy=2 
    SELECT * FROM #temp ORDER BY E9105, EventTime;
  IF @OrderBy=3 
    SELECT * FROM #temp ORDER BY T8512, EventTime;
  IF @OrderBy=4
    SELECT * FROM #temp ORDER BY E8507, EventTime;
END
GO

GRANT EXECUTE ON [GBD].[RapportAvvik] TO [FastTrak]
GO