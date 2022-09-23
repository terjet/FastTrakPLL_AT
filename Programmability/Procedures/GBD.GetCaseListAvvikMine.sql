SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListAvvikMine]( @StudyId INT, @StartAt DateTime, @StopAt DateTime ) AS
BEGIN
  SELECT ce.PersonId, p.DOB, p.ReverseName AS FullName, sg.GroupName, p.GenderId, p.NationalId,
    'Opprettet: ' + dbo.ShortTime( ce.EventTime ) + ', ' + ISNULL(mia.OptionText,'Registrert*') AS InfoText 
  FROM dbo.ClinForm cf
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
  JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
  JOIN dbo.Person p ON p.PersonId=ce.PersonId
  JOIN dbo.StudyGroup sg ON ( sg.StudyId=ce.StudyId ) AND ( sg.GroupId=ce.GroupId ) AND ( sg.GroupActive = 1 )
  LEFT OUTER JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId AND cdp.ItemId = 8512
  LEFT OUTER JOIN dbo.MetaItemAnswer mia ON mia.ItemId = cdp.ItemId AND mia.OrderNumber = cdp.EnumVal
  LEFT OUTER JOIN dbo.StudyUser su ON su.UserId=USER_ID() AND su.StudyId = ce.StudyId
  WHERE ( mf.FormName='GbdAvvik' ) AND ( cf.DeletedAt IS NULL )
  AND ( ce.StudyId=@StudyId ) AND ( ce.EventTime >= @StartAt ) AND ( ce.EventTime < @StopAt )
  AND ( ( su.GroupId=ce.GroupId ) OR ( su.UserId IS NULL ) OR ( su.GroupId IS NULL ) OR ( su.ShowMyGroup = 0 ) )
  AND ( cf.CreatedBy=USER_ID() )
  ORDER BY ce.EventTime DESC;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListAvvikMine] TO [FastTrak]
GO