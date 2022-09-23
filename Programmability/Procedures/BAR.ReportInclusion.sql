SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BAR].[ReportInclusion] ( @StudyId INT ) AS
BEGIN
  SELECT p.PersonId, p.DOB, p.FullName, sg.GroupName, ce.EventTime, ce.StudyId, cf.ClinFormId, 
    DATENAME( mm, ce.EventTime ) AS MonthName,
    DATEPART( hh, ce.EventTime ) AS EventHour,
    DATEPART( ww, ce.EventTime ) AS EventWeek,
    CONVERT(VARCHAR(16),v6166.TextVal) as T6166,
    v6168.EnumVal as E6168,
    a6168.OptionText as T6168,
    v6169.DTVal as T6169,
    v6170.Quantity as T6170,
    v6242.EnumVal as E6242,
    a6242.OptionText as T6242,
    v6243.EnumVal as E6243,
    a6243.OptionText as T6243,
    v6245.EnumVal as E6245,
    a6245.OptionText as T6245,
    v6246.EnumVal as E6246,
    a6246.OptionText as T6246,
    v6247.EnumVal as E6247,
    a6247.OptionText as T6247,
    v6248.EnumVal as E6248,
    a6248.OptionText as T6248,
    v8091.EnumVal as E8091,
    a8091.OptionText as T8091,
    v9319.EnumVal as E9319,
    a9319.OptionText as T9319,
    v9321.EnumVal as E9321,
    a9321.OptionText as T9321,
    cf.FormStatus, cf.FormComplete, cf.Comment,
    up.FullName AS UserFullName, up.Signature as CreatedBySign 
  INTO #temp
  FROM dbo.ClinForm cf
  JOIN dbo.ClinEvent ce ON ( ce.EventId = cf.EventId ) 
  JOIN dbo.StudCase sc ON ( sc.StudyId = ce.StudyId ) AND ( sc.PersonId = ce.PersonId ) 
  JOIN dbo.ViewActiveCaseListStub p ON ( p.PersonId=sc.PersonId ) 
  LEFT OUTER JOIN dbo.StudyGroup sg ON ( sg.StudyId = ce.StudyId ) AND ( sg.GroupId = ce.GroupId ) 
  LEFT OUTER JOIN dbo.UserList ul ON ul.UserId=cf.CreatedBy
  LEFT OUTER JOIN dbo.Person up ON up.PersonId=ul.PersonId 
    LEFT OUTER JOIN dbo.ClinDataPoint v6166 ON v6166.EventId=ce.EventId and v6166.ItemId=6166
    LEFT OUTER JOIN dbo.ClinDataPoint v6168 ON v6168.EventId=ce.EventId and v6168.ItemId=6168
      LEFT OUTER JOIN dbo.MetaItemAnswer a6168 ON a6168.ItemId=6168 and v6168.EnumVal=a6168.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v6169 ON v6169.EventId=ce.EventId and v6169.ItemId=6169
    LEFT OUTER JOIN dbo.ClinDataPoint v6170 ON v6170.EventId=ce.EventId and v6170.ItemId=6170
    LEFT OUTER JOIN dbo.ClinDataPoint v6242 ON v6242.EventId=ce.EventId and v6242.ItemId=6242
      LEFT OUTER JOIN dbo.MetaItemAnswer a6242 ON a6242.ItemId=6242 and v6242.EnumVal=a6242.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v6243 ON v6243.EventId=ce.EventId and v6243.ItemId=6243
      LEFT OUTER JOIN dbo.MetaItemAnswer a6243 ON a6243.ItemId=6243 and v6243.EnumVal=a6243.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v6245 ON v6245.EventId=ce.EventId and v6245.ItemId=6245
      LEFT OUTER JOIN dbo.MetaItemAnswer a6245 ON a6245.ItemId=6245 and v6245.EnumVal=a6245.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v6246 ON v6246.EventId=ce.EventId and v6246.ItemId=6246
      LEFT OUTER JOIN dbo.MetaItemAnswer a6246 ON a6246.ItemId=6246 and v6246.EnumVal=a6246.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v6247 ON v6247.EventId=ce.EventId and v6247.ItemId=6247
      LEFT OUTER JOIN dbo.MetaItemAnswer a6247 ON a6247.ItemId=6247 and v6247.EnumVal=a6247.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v6248 ON v6248.EventId=ce.EventId and v6248.ItemId=6248
      LEFT OUTER JOIN dbo.MetaItemAnswer a6248 ON a6248.ItemId=6248 and v6248.EnumVal=a6248.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v8091 ON v8091.EventId=ce.EventId and v8091.ItemId=8091
      LEFT OUTER JOIN dbo.MetaItemAnswer a8091 ON a8091.ItemId=8091 and v8091.EnumVal=a8091.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v9319 ON v9319.EventId=ce.EventId and v9319.ItemId=9319
      LEFT OUTER JOIN dbo.MetaItemAnswer a9319 ON a9319.ItemId=9319 and v9319.EnumVal=a9319.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v9321 ON v9321.EventId=ce.EventId and v9321.ItemId=9321
      LEFT OUTER JOIN dbo.MetaItemAnswer a9321 ON a9321.ItemId=9321 and v9321.EnumVal=a9321.OrderNumber
  WHERE cf.FormId=763;
  SELECT * FROM #temp ORDER BY PersonId;
END
GO

GRANT EXECUTE ON [BAR].[ReportInclusion] TO [FastTrak]
GO