SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetAddisonNoRecentData]( @StudyId INT ) AS
BEGIN
  -- Find Addison patients
  SELECT DISTINCT ce.PersonId
  INTO #temp 
  FROM dbo.ClinEvent ce 
  JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId
  WHERE cdp.ItemId = 6299 AND cdp.EnumVal = 1
  UNION
  SELECT DISTINCT ce.PersonId FROM dbo.ClinEvent ce 
  JOIN dbo.ClinDataPoint cdp ON cdp.EventId = ce.EventId
  WHERE cdp.ItemId = 6090 AND cdp.EnumVal = 1
  EXCEPT 
  SELECT DISTINCT ce.PersonId FROM dbo.ClinForm cf
  JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId  
  JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId
  WHERE FormName IN ( 'Autoimmunitet','Addison' )
  AND ce.EventTime > '2013-01-01';
  -- Join with active patients
  SELECT DISTINCT v.*,ISNULL(p.PostalCode,'') + ' ' + ISNULL(p.City,'') AS InfoText 
  FROM dbo.ViewActiveCaseListStub v
  JOIN #temp t ON t.PersonId=v.PersonId  
  JOIN dbo.Person p ON p.PersonId = v.PersonId AND ISNULL(DeceasedInd,0) = 0
  WHERE v.StudyId=@StudyId
  ORDER BY v.FullName;                        
END
GO

GRANT EXECUTE ON [ENDO].[GetAddisonNoRecentData] TO [FastTrak]
GO