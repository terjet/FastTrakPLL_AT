SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[InfectionReport] ( @StudyId INT, @StartAt DateTime = NULL, @StopAt DateTime = NULL ) AS
BEGIN
  SET LANGUAGE Norwegian; 
  IF @StartAt IS NULL SET @StartAt = GETDATE()-365;
  IF @StopAt IS NULL SET @StopAt = GETDATE();
  /* Conform to Population field names */
  SELECT 
    sc.PersonId, sg.CenterId, sg.GroupId, sg.GroupName, 
    ce.EventId, ce.EventTime, 
    cf.ClinFormId, cf.FormStatus, cf.FormComplete, cf.Comment,
    dbo.MonthYear( ce.EventTime ) AS MonthYear,
    DATENAME( mm, ce.EventTime ) AS MonthName,
    DATEPART( hh, ce.EventTime ) AS EventHour,
    DATEPART( ww, ce.EventTime ) AS EventWeek,
    v768.DTVal AS T768,
    v769.EnumVal AS E769,
    a769.OptionText AS T769,
    CONVERT(VARCHAR(16),v771.TextVal) AS T771,
    v777.EnumVal AS E777,
    a777.OptionText AS T777,
    v778.EnumVal AS E778,
    a778.OptionText AS T778,
    CONVERT(VARCHAR(16),v3495.TextVal) AS T3495,
    v3498.EnumVal AS E3498,
    a3498.OptionText AS T3498,
    v3499.EnumVal AS E3499,
    a3499.OptionText AS T3499,
    v3500.DTVal AS T3500,
    cf.CreatedAt, cf.CreatedBy, 
    pcr.Signature AS CreatedBySign, pcr.FullName AS CreatedByName, 
    ROW_NUMBER() OVER ( PARTITION BY ce.PersonId ORDER BY EventTime DESC ) AS OrderNo 
  FROM dbo.ClinForm cf
  JOIN dbo.ClinEvent ce ON ( ce.EventId = cf.EventId ) 
  JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId 
  JOIN dbo.StudCase sc ON ( sc.StudyId = ce.StudyId ) AND ( sc.PersonId = ce.PersonId ) 
  JOIN dbo.StudyGroup sg ON ( sg.StudyId = ce.StudyId ) AND ( sg.GroupId = ce.GroupId ) 
  JOIN dbo.StudyUser su ON ( su.StudyId = sg.StudyId ) AND ( su.UserId = USER_ID() ) 
  JOIN dbo.UserList my ON ( my.UserId = USER_ID() ) 
  JOIN dbo.StudyCenter c ON ( c.CenterId = sg.CenterId ) 
  JOIN dbo.UserList ucr ON ucr.UserId = cf.CreatedBy
  LEFT OUTER JOIN dbo.Person pcr ON pcr.PersonId = ucr.PersonId 
    LEFT OUTER JOIN dbo.ClinDataPoint v768 ON v768.EventId=ce.EventId AND v768.ItemId = 768
    LEFT OUTER JOIN dbo.ClinDataPoint v769 ON v769.EventId=ce.EventId AND v769.ItemId = 769
      LEFT OUTER JOIN dbo.MetaItemAnswer a769 ON a769.ItemId=769 AND v769.EnumVal = a769.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v771 ON v771.EventId=ce.EventId AND v771.ItemId = 771
    LEFT OUTER JOIN dbo.ClinDataPoint v777 ON v777.EventId=ce.EventId AND v777.ItemId = 777
      LEFT OUTER JOIN dbo.MetaItemAnswer a777 ON a777.ItemId=777 AND v777.EnumVal = a777.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v778 ON v778.EventId=ce.EventId AND v778.ItemId = 778
      LEFT OUTER JOIN dbo.MetaItemAnswer a778 ON a778.ItemId=778 AND v778.EnumVal = a778.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v3495 ON v3495.EventId=ce.EventId AND v3495.ItemId = 3495
    LEFT OUTER JOIN dbo.ClinDataPoint v3498 ON v3498.EventId=ce.EventId AND v3498.ItemId = 3498
      LEFT OUTER JOIN dbo.MetaItemAnswer a3498 ON a3498.ItemId=3498 AND v3498.EnumVal = a3498.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v3499 ON v3499.EventId=ce.EventId AND v3499.ItemId = 3499
      LEFT OUTER JOIN dbo.MetaItemAnswer a3499 ON a3499.ItemId=3499 AND v3499.EnumVal = a3499.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v3500 ON v3500.EventId=ce.EventId AND v3500.ItemId=3500
  WHERE ( cf.DeletedAt IS NULL )
    AND ( mf.FormName='GBD_INFECTION' )
    AND ( ( su.GroupId = sg.GroupId ) OR ( su.ShowMyGroup = 0 ) ) 
    AND ( sg.CenterId = my.CenterId ) 
    AND ( sc.StudyId = @StudyId ) 
    AND ( ce.EventTime >= @StartAt ) AND ( ce.EventTime < @StopAt )
  ORDER BY ce.EventTime DESC;
END
GO

GRANT EXECUTE ON [GBD].[InfectionReport] TO [Farmasøyt]
GO

GRANT EXECUTE ON [GBD].[InfectionReport] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[InfectionReport] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[InfectionReport] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[InfectionReport] TO [Vernepleier]
GO