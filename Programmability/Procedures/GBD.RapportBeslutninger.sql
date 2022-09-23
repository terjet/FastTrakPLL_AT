SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RapportBeslutninger]( @StudyId INT ) AS
BEGIN
  SET LANGUAGE Norwegian; 
  SELECT * FROM
  (
    SELECT 
      v.PersonId, v.DOB, v.FullName, v.GroupName, p.GenderId, p.NationalId, -- Kan også brukes som populasjon
      ce.EventId, ce.EventTime, 
      cf.ClinFormId, cf.FormStatus, cf.FormComplete, cf.Comment,
      dbo.MonthYear( ce.EventTime ) AS MonthYear, 
      DATENAME( mm, ce.EventTime ) AS MonthName,
      DATEPART( hh, ce.EventTime ) AS EventHour,
      DATEPART( ww, ce.EventTime ) AS EventWeek,
      v3437.EnumVal AS E3437, a3437.OptionText AS T3437, -- Gjenopplivning
      v2832.EnumVal AS E2832, a2832.OptionText AS T2832, -- Behandlingsintensitet
      v3439.EnumVal AS E3439, a3439.OptionText AS T3439, -- Organdonasjon
      v3440.EnumVal AS E3440, a3440.OptionText AS T3440, -- Kan obduseres
      v3441.EnumVal AS E3441, a3441.OptionText AS T3441, -- Kan motta tranfusjon
      cf.CreatedAt, cf.CreatedBy, 
      pcr.Signature AS CreatedBySign, pcr.FullName AS CreatedByName, 
      ROW_NUMBER() OVER ( PARTITION BY ce.PersonId ORDER BY ce.EventTime DESC ) AS ReverseOrder
    FROM dbo.ClinForm cf
    JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId 
    JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId 
    JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = ce.PersonId
    JOIN dbo.Person p ON p.PersonId = v.PersonId 
    JOIN dbo.UserList ucr ON ucr.UserId = cf.CreatedBy
    LEFT JOIN dbo.Person pcr ON pcr.PersonId = ucr.PersonId 
    LEFT JOIN dbo.ClinDataPoint v3437 ON v3437.EventId=ce.EventId AND v3437.ItemId = 3437
      LEFT JOIN dbo.MetaItemAnswer a3437 ON a3437.ItemId=3437 AND v3437.EnumVal=a3437.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v2832 ON v2832.EventId=ce.EventId AND v2832.ItemId = 2832
      LEFT JOIN dbo.MetaItemAnswer a2832 ON a2832.ItemId=2832 AND v2832.EnumVal=a2832.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v3439 ON v3439.EventId=ce.EventId AND v3439.ItemId = 3439
      LEFT JOIN dbo.MetaItemAnswer a3439 ON a3439.ItemId=3439 AND v3439.EnumVal=a3439.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v3440 ON v3440.EventId=ce.EventId AND v3440.ItemId = 3440
      LEFT JOIN dbo.MetaItemAnswer a3440 ON a3440.ItemId=3440 AND v3440.EnumVal=a3440.OrderNumber
    LEFT JOIN dbo.ClinDataPoint v3441 ON v3441.EventId=ce.EventId AND v3441.ItemId = 3441
      LEFT JOIN dbo.MetaItemAnswer a3441 ON a3441.ItemId=3441 AND v3441.EnumVal = a3441.OrderNumber
    WHERE ( cf.DeletedAt IS NULL ) AND ( v.StudyId = @StudyId ) AND ( mf.FormName='GBD_BESLUTNINGER' )
  ) allforms
  WHERE allforms.ReverseOrder = 1
  ORDER BY GroupName, FullName;
END
GO

GRANT EXECUTE ON [GBD].[RapportBeslutninger] TO [FastTrak]
GO