SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[RapportSvangerskapskontroller]( @StartDate DateTime, @StopDate DateTime ) AS
BEGIN
  SELECT ce.PersonId,p.DOB,p.ReverseName,c.CenterName, cdp.EnumVal,mia.OptionText as DiabetesType,
  MIN(ce.EventTime) as FirstVisit, COUNT(*) AS VisitCount
  FROM dbo.ClinForm cf 
  JOIN dbo.ClinEvent ce ON ce.EventId=cf.EventId
  JOIN dbo.StudyGroup sg ON sg.StudyId=ce.StudyId and sg.GroupId=ce.GroupId
  JOIN dbo.StudyCenter c ON c.CenterId=sg.CenterId
  JOIN dbo.ClinDataPoint cdp ON cdp.EventId=ce.EventId AND cdp.ItemId=3196
  JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId
  JOIN dbo.MetaItemAnswer mia on mia.ItemId=cdp.ItemId AND mia.OrderNumber=cdp.EnumVal
  JOIN dbo.Person p ON p.PersonId=ce.PersonId AND p.GenderId=2
  JOIN dbo.UserList ul ON ul.UserId=USER_ID() AND ul.CenterId=sg.CenterId
  WHERE
    ( cf.DeletedAt IS NULL AND mf.FormName = 'DIAPOL_GRAVIDE' ) AND ( ce.EventTime >= @StartDate ) AND ( ce.EventTime < @StopDate )
  GROUP BY ce.PersonId,p.DOB,p.ReverseName,c.CenterName,cdp.EnumVal,mia.OptionText
  ORDER BY c.CenterName,cdp.EnumVal,ce.PersonId
END
GO

GRANT EXECUTE ON [NDV].[RapportSvangerskapskontroller] TO [FastTrak]
GO