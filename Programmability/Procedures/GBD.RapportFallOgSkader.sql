SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RapportFallOgSkader]( @StudyId INT, @StartAt DateTime = NULL, @StopAt DateTime = NULL, @OrderBy INT = 0 ) AS
BEGIN
  SET LANGUAGE Norwegian; 
  IF @StartAt IS NULL SET @StartAt = GETDATE()-365;
  IF @StopAt IS NULL SET @StopAt = GETDATE();
                     
  /* Get relevant forms (GbdAvvik) except when the form GBD_SKADE is on same event */
  SELECT cf.ClinFormId
    INTO #formEventList 
    FROM dbo.ClinForm cf 
    JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
    JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
    JOIN dbo.ClinDataPoint cdp ON cdp.EventId = cf.EventId AND cdp.ItemId = 3580
  WHERE ce.StudyId=@StudyId AND mf.FormName = 'GbdAvvik' AND cdp.EnumVal in (1,2,3) 
    AND NOT cf.EventId IN (SELECT EventId FROM dbo.ClinForm JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId WHERE mf.FormName='GBD_SKADE' AND DeletedAt IS NULL)
    AND ( ce.EventTime >= @StartAt ) AND ( ce.EventTime < @StopAt )
  UNION
  /* Add relevant forms (GBD_SKADE) */
  SELECT cf.ClinFormId 
    FROM dbo.ClinForm cf
    JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
    JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
  WHERE ce.StudyId=@StudyId AND mf.FormName = 'GBD_SKADE'
    AND ( ce.EventTime >= @StartAt ) AND ( ce.EventTime < @StopAt );

  /* Retrieve dataset, field order conforms to population specification */
  SELECT 
    sc.PersonId, p.DOB, p.FullName, p.ReverseName, p.GenderId, p.NationalId, sg.CenterId, sg.GroupId, sg.GroupName, 
    ce.EventId, ce.EventTime, cf.ClinFormId, cf.FormStatus, cf.FormComplete, cf.Comment,
    dbo.MonthYear( ce.EventTime ) AS MonthYear,
    DATENAME( mm, ce.EventTime ) AS MonthName,
    DATEPART( hh, ce.EventTime ) AS EventHour,
    DATEPART( ww, ce.EventTime ) AS EventWeek,
    v3574.Quantity AS T3574,
    v3575.EnumVal AS E3575,
    a3575.OptionText AS T3575,
    v3576.EnumVal AS E3576,
    a3576.OptionText AS T3576,
    v3578.EnumVal AS E3578,
    a3578.OptionText AS T3578,
    v3579.EnumVal AS E3579,
    a3579.OptionText AS T3579,
    v3580.EnumVal AS E3580,
    a3580.OptionText AS T3580,
    v3581.EnumVal AS E3581,
    a3581.OptionText AS T3581,
    v3582.EnumVal AS E3582,
    a3582.OptionText AS T3582,
    v6402.EnumVal AS E6402,
    a6402.OptionText AS T6402,
    cf.CreatedAt, cf.CreatedBy, 
    pcr.Signature AS CreatedBySign, pcr.FullName AS CreatedByName, 
    ROW_NUMBER() OVER ( PARTITION BY ce.PersonId ORDER BY EventTime DESC ) AS OrderNo 
  INTO #temp
  FROM #formEventList fel
  JOIN dbo.ClinForm cf ON cf.ClinFormId = fel.ClinFormId 
  JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId  
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId 
  JOIN dbo.StudCase sc ON ( sc.StudyId = ce.StudyId ) AND ( sc.PersonId = ce.PersonId ) 
  JOIN dbo.Person p ON ( p.PersonId = sc.PersonId ) 
  JOIN dbo.StudyGroup sg ON ( sg.StudyId = ce.StudyId ) AND ( sg.GroupId = ce.GroupId ) 
  JOIN dbo.StudyUser su ON ( su.StudyId = sg.StudyId ) AND ( su.UserId = USER_ID() ) 
  JOIN dbo.UserList my ON ( my.UserId = USER_ID() ) 
  JOIN dbo.StudyCenter c ON ( c.CenterId = sg.CenterId ) 
  JOIN dbo.UserList ucr ON ucr.UserId = cf.CreatedBy
  LEFT OUTER JOIN dbo.Person pcr ON pcr.PersonId = ucr.PersonId 
    LEFT OUTER JOIN dbo.ClinDataPoint v3574 ON v3574.EventId = ce.EventId AND v3574.ItemId = 3574
    LEFT OUTER JOIN dbo.ClinDataPoint v3575 ON v3575.EventId = ce.EventId AND v3575.ItemId = 3575
      LEFT OUTER JOIN dbo.MetaItemAnswer a3575 ON a3575.ItemId = 3575 AND v3575.EnumVal = a3575.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v3576 ON v3576.EventId = ce.EventId AND v3576.ItemId = 3576
      LEFT OUTER JOIN dbo.MetaItemAnswer a3576 ON a3576.ItemId = 3576 AND v3576.EnumVal = a3576.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v3578 ON v3578.EventId = ce.EventId AND v3578.ItemId = 3578
      LEFT OUTER JOIN dbo.MetaItemAnswer a3578 ON a3578.ItemId = 3578 AND v3578.EnumVal = a3578.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v3579 ON v3579.EventId = ce.EventId AND v3579.ItemId = 3579
      LEFT OUTER JOIN dbo.MetaItemAnswer a3579 ON a3579.ItemId = 3579 AND v3579.EnumVal = a3579.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v3580 ON v3580.EventId = ce.EventId AND v3580.ItemId = 3580
      LEFT OUTER JOIN dbo.MetaItemAnswer a3580 ON a3580.ItemId = 3580 AND v3580.EnumVal = a3580.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v3581 ON v3581.EventId = ce.EventId AND v3581.ItemId = 3581
      LEFT OUTER JOIN dbo.MetaItemAnswer a3581 ON a3581.ItemId = 3581 AND v3581.EnumVal = a3581.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v3582 ON v3582.EventId = ce.EventId AND v3582.ItemId = 3582
      LEFT OUTER JOIN dbo.MetaItemAnswer a3582 ON a3582.ItemId = 3582 AND v3582.EnumVal = a3582.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v6402 ON v6402.EventId = ce.EventId AND v6402.ItemId = 6402
      LEFT OUTER JOIN dbo.MetaItemAnswer a6402 ON a6402.ItemId = 6402 AND v6402.EnumVal = a6402.OrderNumber
  WHERE ( cf.DeletedAt IS NULL )
    AND ( ( su.GroupId = sg.GroupId ) OR ( su.ShowMyGroup = 0 ) ) 
    AND ( sg.CenterId = my.CenterId ) 
    AND ( sc.StudyId = @StudyId )
    AND ( ce.EventTime >= @StartAt ) AND ( ce.EventTime < @StopAt )
  
  /* Select final dataset from temp table 
     - OrderBy=0 => Order by Month (EventTime)
     - OrderBy=1 => Order by Group, PersonId, EventTime
     - OrderBy=2 => Order by T3580 (Skadetype), EventTime
  */     
  IF @OrderBy=0 
    SELECT * FROM #temp ORDER BY EventTime;
  
  IF @OrderBy=1 
    SELECT * FROM #temp ORDER BY GroupId, PersonId, EventTime;

  IF @OrderBy=2 
    SELECT * FROM #temp ORDER BY T3580, EventTime;

END
GO

GRANT EXECUTE ON [GBD].[RapportFallOgSkader] TO [FastTrak]
GO