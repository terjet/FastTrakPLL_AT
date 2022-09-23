SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RapportKontaktinfo] ( @StudyId INT ) AS
BEGIN
  SET LANGUAGE Norwegian; 
  SELECT a.* FROM
  (
  SELECT 
    v.PersonId, v.DOB, v.FullName, v.GenderId, v.GroupName, 
    ce.EventId, ce.EventTime, 
    cf.ClinFormId, cf.FormStatus, cf.FormComplete, cf.Comment,
    dbo.MonthYear( ce.EventTime ) AS MonthYear,
    DATENAME( mm, ce.EventTime ) AS MonthName,
    DATEPART( hh, ce.EventTime ) AS EventHour,
    DATEPART( ww, ce.EventTime ) AS EventWeek,
    v122.EnumVal AS E122,
    a122.OptionText AS T122,
    CONVERT(VARCHAR(64),v3424.TextVal) AS T3424,
    CONVERT(VARCHAR(64),v3425.TextVal) AS T3425,
    CONVERT(VARCHAR(64),v3426.TextVal) AS T3426,
    CONVERT(VARCHAR(64),v3427.TextVal) AS T3427,
    CONVERT(VARCHAR(16),v3433.TextVal) AS T3433,
    CONVERT(VARCHAR(64),v9318.TextVal) AS T9318,
    cf.CreatedAt, cf.CreatedBy, 
    pcr.Signature AS CreatedBySign, pcr.FullName AS CreatedByName, 
    ROW_NUMBER() OVER ( PARTITION BY ce.PersonId ORDER BY EventTime DESC ) AS OrderNo 
  FROM dbo.ClinForm cf
  JOIN dbo.ClinEvent ce ON ( ce.EventId = cf.EventId ) 
  JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId 
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId=ce.PersonId 
  JOIN dbo.UserList ucr ON ucr.UserId=cf.CreatedBy
    LEFT OUTER JOIN dbo.Person pcr ON pcr.PersonId=ucr.PersonId 
    LEFT OUTER JOIN dbo.ClinDataPoint v122 ON v122.EventId=ce.EventId AND v122.ItemId = 122
      LEFT OUTER JOIN dbo.MetaItemAnswer a122 ON a122.ItemId=122 and v122.EnumVal=a122.OrderNumber
    LEFT OUTER JOIN dbo.ClinDataPoint v3424 ON v3424.EventId=ce.EventId AND v3424.ItemId = 3424
    LEFT OUTER JOIN dbo.ClinDataPoint v3425 ON v3425.EventId=ce.EventId AND v3425.ItemId = 3425
    LEFT OUTER JOIN dbo.ClinDataPoint v3426 ON v3426.EventId=ce.EventId AND v3426.ItemId = 3426
    LEFT OUTER JOIN dbo.ClinDataPoint v3427 ON v3427.EventId=ce.EventId AND v3427.ItemId = 3427
    LEFT OUTER JOIN dbo.ClinDataPoint v3433 ON v3433.EventId=ce.EventId AND v3433.ItemId = 3433
    LEFT OUTER JOIN dbo.ClinDataPoint v9318 ON v9318.EventId=ce.EventId AND v9318.ItemId = 9318
  WHERE ( cf.DeletedAt IS NULL )
    AND ( mf.FormName='GBD_PASADMIN' )
    AND ( v.StudyId=@StudyId ) 
  ) a
  WHERE a.OrderNo = 1
  ORDER BY a.FullName;
END
GO

GRANT EXECUTE ON [GBD].[RapportKontaktinfo] TO [FastTrak]
GO