SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListInjuries6Months]( @StudyId INT ) AS
BEGIN
  DECLARE @Counts TABLE (PersonId INT, InjuryRegistrations INT, Falls INT)
  DECLARE @LatestRegistrations TABLE (PersonId INT, EventId INT, GroupId INT)

  SELECT ce.PersonId, ce.EventId, ce.EventTime, cdp.EnumVal, ce.GroupId 
  INTO #Temp 
  FROM dbo.ClinEvent ce
  JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = 'GBD_SKADE'
  JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId AND cdp.ItemId = 9391
  JOIN dbo.StudyGroup sg ON sg.StudyId = ce.StudyId AND sg.GroupId = ce.GroupId
  JOIN dbo.UserList ul ON ul.CenterId = sg.CenterId AND ul.UserId = USER_ID()
  WHERE DATEDIFF( DD, ce.EventTime, GETDATE() ) < 183
  ORDER BY ce.EventTime DESC;

  INSERT @Counts
  SELECT t.PersonId, COUNT(*), SUM( CASE WHEN enumval = 1 THEN 1 ELSE 0 END )
  FROM #Temp t
  GROUP BY t.PersonId;

  INSERT @LatestRegistrations
  SELECT part.PersonId, part.EventId, part.GroupId 
  FROM 
  ( 
    SELECT *, ROW_NUMBER()
      OVER ( PARTITION BY t.PersonId ORDER BY t.EventId DESC ) AS OrderNo
    FROM #Temp t 
   ) part
  WHERE part.OrderNo = 1;

  SELECT p.PersonId, p.DOB, p.FullName, sg.GroupId, sg.GroupName, p.GenderId, CONVERT( VARCHAR, InjuryRegistrations ) + ' skaderegistreringer, hvorav ' + 
    CONVERT( VARCHAR, Falls ) + ' fall' AS InfoText 
  FROM dbo.Person p
  JOIN @Counts Counts ON Counts.PersonId = p.PersonId
  JOIN @LatestRegistrations Latest ON Latest.PersonId = Counts.PersonId
  JOIN dbo.StudyGroup sg ON sg.StudyId = @StudyId AND sg.GroupId = Latest.GroupId
  ORDER BY InjuryRegistrations DESC, Falls DESC, FullName;
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListInjuries6Months] TO [FastTrak]
GO