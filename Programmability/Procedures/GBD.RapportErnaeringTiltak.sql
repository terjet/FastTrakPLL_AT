SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RapportErnaeringTiltak]( @StudyId INT, @StartAt DateTime = NULL, @StopAt DateTime = NULL ) AS
BEGIN
  IF @StartAt IS NULL SET @StartAt = GETDATE()-365;
  IF @StopAt IS NULL SET @StopAt = GETDATE();
  SELECT 
    v.*, v.FullName AS ReverseName, 
    ce.EventId, ce.EventTime, 
    cf.ClinFormId, cf.FormStatus, cf.FormComplete, cf.Comment,
    dbo.MonthYear( ce.EventTime ) AS MonthYear,
    DATENAME( mm, ce.EventTime ) AS MonthName,
    DATEPART( hh, ce.EventTime ) AS EventHour,
    DATEPART( ww, ce.EventTime ) AS EventWeek,
    v4357.EnumVal AS E4357,
    a4357.OptionText AS T4357,
    v4850.EnumVal AS E4850,
    a4850.OptionText AS T4850,
    v4896.EnumVal AS E4896,
    a4896.OptionText AS T4896,
    v4897.DTVal AS T4897,
    CONVERT(VARCHAR(64),v5206.TextVal) AS T5206,
    v5207.EnumVal AS E5207,
    a5207.OptionText AS T5207,
    CONVERT(VARCHAR(16),v5459.TextVal) AS T5459,
    v5460.EnumVal AS E5460,
    a5460.OptionText AS T5460,
    CONVERT(VARCHAR(16),v5461.TextVal) AS T5461,
    v5462.EnumVal AS E5462,
    a5462.OptionText AS T5462,
    v5464.EnumVal AS E5464,
    a5464.OptionText AS T5464,
    v5466.EnumVal AS E5466,
    a5466.OptionText AS T5466,
    CONVERT(VARCHAR(16),v5467.TextVal) AS T5467,
    v5468.EnumVal AS E5468,
    a5468.OptionText AS T5468,
    CONVERT(VARCHAR(16),v5469.TextVal) AS T5469,
    CONVERT(VARCHAR(16),v5472.TextVal) AS T5472,
    v5478.DTVal AS T5478,
    cf.CreatedAt, cf.CreatedBy, 
    pcr.Signature AS CreatedBySign, pcr.FullName AS CreatedByName, 
    ROW_NUMBER() OVER ( PARTITION BY ce.PersonId ORDER BY EventTime DESC ) AS OrderNo 
  FROM dbo.ClinForm cf
  JOIN dbo.ClinEvent ce ON ( ce.StudyId = @StudyId ) AND ( ce.EventId = cf.EventId )  
  JOIN dbo.MetaForm mf ON ( mf.FormId = cf.FormId )
  JOIN dbo.ViewActiveCaseListStub v ON ( v.StudyId = ce.StudyId ) AND ( v.PersonId = ce.PersonId )
  JOIN dbo.UserList ucr ON ucr.UserId = cf.CreatedBy
  LEFT JOIN dbo.Person pcr ON pcr.PersonId = ucr.PersonId 
    LEFT JOIN dbo.ClinDataPoint v4357 ON v4357.EventId = ce.EventId AND v4357.ItemId = 4357
      LEFT JOIN dbo.MetaItemAnswer a4357 ON a4357.ItemId = 4357 AND v4357.EnumVal = a4357.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v4850 ON v4850.EventId = ce.EventId AND v4850.ItemId = 4850
      LEFT JOIN dbo.MetaItemAnswer a4850 ON a4850.ItemId = 4850 AND v4850.EnumVal = a4850.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v4896 ON v4896.EventId = ce.EventId AND v4896.ItemId = 4896
      LEFT JOIN dbo.MetaItemAnswer a4896 ON a4896.ItemId = 4896 AND v4896.EnumVal = a4896.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v4897 ON v4897.EventId = ce.EventId AND v4897.ItemId = 4897
    LEFT JOIN dbo.ClinDataPoint v5206 ON v5206.EventId = ce.EventId AND v5206.ItemId = 5206
    LEFT JOIN dbo.ClinDataPoint v5207 ON v5207.EventId = ce.EventId AND v5207.ItemId = 5207
      LEFT JOIN dbo.MetaItemAnswer a5207 ON a5207.ItemId = 5207 AND v5207.EnumVal = a5207.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v5459 ON v5459.EventId = ce.EventId AND v5459.ItemId = 5459
    LEFT JOIN dbo.ClinDataPoint v5460 ON v5460.EventId = ce.EventId AND v5460.ItemId = 5460
      LEFT JOIN dbo.MetaItemAnswer a5460 ON a5460.ItemId = 5460 AND v5460.EnumVal = a5460.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v5461 ON v5461.EventId = ce.EventId AND v5461.ItemId = 5461
    LEFT JOIN dbo.ClinDataPoint v5462 ON v5462.EventId = ce.EventId AND v5462.ItemId = 5462
      LEFT JOIN dbo.MetaItemAnswer a5462 ON a5462.ItemId = 5462 AND v5462.EnumVal = a5462.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v5464 ON v5464.EventId = ce.EventId AND v5464.ItemId = 5464
      LEFT JOIN dbo.MetaItemAnswer a5464 ON a5464.ItemId = 5464 AND v5464.EnumVal = a5464.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v5466 ON v5466.EventId = ce.EventId AND v5466.ItemId = 5466
      LEFT JOIN dbo.MetaItemAnswer a5466 ON a5466.ItemId = 5466 AND v5466.EnumVal = a5466.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v5467 ON v5467.EventId = ce.EventId AND v5467.ItemId = 5467
    LEFT JOIN dbo.ClinDataPoint v5468 ON v5468.EventId = ce.EventId AND v5468.ItemId = 5468
      LEFT JOIN dbo.MetaItemAnswer a5468 ON a5468.ItemId = 5468 AND v5468.EnumVal = a5468.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v5469 ON v5469.EventId=ce.EventId AND v5469.ItemId = 5469
    LEFT JOIN dbo.ClinDataPoint v5472 ON v5472.EventId=ce.EventId AND v5472.ItemId = 5472
    LEFT JOIN dbo.ClinDataPoint v5478 ON v5478.EventId=ce.EventId AND v5478.ItemId = 5478
  WHERE ( cf.DeletedAt IS NULL )
    AND ( ce.EventTime >= @StartAt ) AND ( ce.EventTime < @StopAt )
    AND ( mf.FormName='GbdErnaeringTiltak' )
  ORDER BY ce.EventTime DESC;
END
GO

GRANT EXECUTE ON [GBD].[RapportErnaeringTiltak] TO [FastTrak]
GO