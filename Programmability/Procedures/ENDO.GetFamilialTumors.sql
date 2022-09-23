SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetFamilialTumors]( @StudyId INT ) AS
BEGIN  

  SELECT ce.PersonId
  INTO #temp1
  FROM dbo.ClinDataPoint cdp
  JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
  WHERE ( cdp.ItemId = 5745 ) AND ( cdp.EnumVal = 1 )

  UNION
  
  SELECT ce.PersonId
  FROM dbo.ClinDataPoint cdp
  JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
  WHERE ( cdp.ItemId = 6981 ) AND ( cdp.EnumVal IN ( 1,2,3,4 ) );
  
  -- Få unik personliste
  
  SELECT PersonId,COUNT(*) AS HitCount 
  INTO #temp2 
  FROM #temp1 GROUP BY PersonId;
  
  -- Hent pasientene
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName, 'Kriterier = ' + CONVERT(VARCHAR,t.HitCount) AS InfoText
    FROM dbo.ViewCaseListStub v
    JOIN #temp2 t ON t.PersonId=v.PersonId
  WHERE v.StudyId=@StudyId
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [ENDO].[GetFamilialTumors] TO [FastTrak]
GO