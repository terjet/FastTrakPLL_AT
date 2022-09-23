SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetAnnualControls]( @StudyId INT, @StartDate DateTime, @StopDate DateTime ) AS
BEGIN
  SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, 'Type ' + mia.ShortCode AS GroupName, 'Uansett status' AS StatusText, 
    p.GenderId, p.NationalId, a.DiabetesType, 'Kontroll ' + dbo.LongTime( a.LastVisit ) AS InfoText
  FROM 
  (
    SELECT ce.PersonId, MIN(cdp.EnumVal) AS DiabetesType, MAX(ce.EventTime) AS LastVisit, COUNT(*) AS VisitCount
    FROM dbo.ClinForm cf 
      JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
      JOIN dbo.StudyGroup sg ON sg.StudyId = ce.StudyId and sg.GroupId=ce.GroupId
      JOIN dbo.StudyCenter c ON c.CenterId = sg.CenterId
      JOIN dbo.UserList ul ON ul.UserId=USER_ID() AND ul.CenterId=sg.CenterId
      JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId AND cdp.ItemId=3196
      JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId
    WHERE ( cf.DeletedAt IS NULL AND mf.FormName = 'DIAPOL_YEAR' ) AND ( ce.EventTime >= @StartDate ) AND ( ce.EventTime < @StopDate )
    GROUP BY ce.PersonId,cdp.EnumVal
  ) a
  JOIN dbo.Person p ON p.PersonId=a.PersonId
  JOIN dbo.MetaItemAnswer mia on mia.ItemId=3196 AND mia.OrderNumber=a.DiabetesType
  ORDER BY a.LastVisit DESC
END
GO

GRANT EXECUTE ON [NDV].[GetAnnualControls] TO [FastTrak]
GO