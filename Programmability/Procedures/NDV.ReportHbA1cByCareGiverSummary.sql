SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportHbA1cByCareGiverSummary]( @StudyId INT, @DiaType INT, @MinCount INT ) AS
BEGIN

  SET NOCOUNT ON;   
  
  DECLARE @TotalGroupName VARCHAR(50) = 'Totalt';

  -- Group by last visited professional 

  SELECT PersonId, UserId, ProfName, ReverseName, CONVERT(DATE,EventTime) AS EventDate
  INTO #LastStudyVisit
  FROM
  (
    SELECT ce.PersonId, ul.UserId, mp.ProfName, p.ReverseName, ROW_NUMBER() OVER (PARTITION BY ce.PersonId ORDER BY ce.EventNum DESC ) AS ReverseOrder, ce.EventTime
    FROM dbo.ClinEvent ce
    JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId -- and not here
    JOIN dbo.MetaStudyForm msf ON msf.FormId = cf.FormId AND msf.StudyId = @StudyId -- ENDO/NDV makes it necessary to use StudyId here
    JOIN dbo.UserList ul ON ul.UserId = ce.CreatedBy 
    JOIN dbo.Person p ON p.PersonId = ul.PersonId
    JOIN dbo.MetaProfession mp ON mp.ProfId = ul.ProfId AND mp.ProfType IN ( 'LE','SP' )
    WHERE ce.EventTime > GETDATE() - 456
  ) agg WHERE agg.ReverseOrder = 1;
  
-- Retrieve the latest HbA1c-values first

  SELECT v.PersonId, sv.UserId, sv.ReverseName, sv.ProfName, ld.NumResult
  INTO #labdata
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastLabDataTable( 1058, GETDATE()) ld ON ld.PersonId = v.PersonId
  JOIN #LastStudyVisit sv ON sv.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable( 3196, NULL ) diatype ON diatype.PersonId = ld.PersonId
  WHERE ( v.StudyId = @StudyId ) 
    AND ( diatype.EnumVal = @DiaType OR @DiaType IS NULL OR @DiaType < 1 ); 

  -- Group by physician and various levels
  
  SELECT 1 AS SortOrder, alle.UserId AS GroupId, alle.ReverseName AS GroupName, alle.ProfName, alle.n AS nAll, 
    b50.n AS n50, b53.n AS n53, b58.n AS n58, a75.n AS n75, 
    100.0 * b50.n / alle.n AS b50p, 
    100.0 * b53.n / alle.n AS b53p, 
    100.0 * b58.n / alle.n AS b58p, 
    100.0 * a75.n / alle.n AS a75p
  FROM (
    SELECT UserId, ReverseName, ProfName, COUNT(*) n
    FROM #labdata
    GROUP BY UserId, ReverseName, ProfName
    ) alle
  LEFT JOIN (
    SELECT UserId, COUNT(*) n
    FROM #labdata
    WHERE NumResult < 50
    GROUP BY UserId
    ) b50 ON b50.UserId = alle.UserId
  LEFT JOIN (
    SELECT UserId, COUNT(*) n
    FROM #labdata
    WHERE NumResult < 53
    GROUP BY UserId
    ) b53 ON b53.UserId = alle.UserId
  LEFT JOIN (
    SELECT UserId, COUNT(*) n
    FROM #labdata
    WHERE NumResult < 58
    GROUP BY UserId
    ) b58 ON b58.UserId = alle.UserId
  LEFT JOIN (
    SELECT UserId, COUNT(*) n
    FROM #labdata
    WHERE NumResult >= 75
    GROUP BY UserId
    ) a75 ON a75.UserId = alle.UserId 

 WHERE alle.n >= @MinCount     

UNION 

-- Add a row for all groups put together

  SELECT 2, 999999, @TotalGroupName, @TotalGroupName, alle.n, b50.n, b53.n, b58.n, a75.n, 
    100.0 * b50.n / alle.n AS b50p, 
    100.0 * b53.n / alle.n AS b53p, 
    100.0 * b58.n / alle.n AS b58p, 
    100.0 * a75.n / alle.n AS a75p
  FROM (
    SELECT COUNT(*) n
    FROM #labdata
    ) alle
  CROSS JOIN (
    SELECT COUNT(*) n
    FROM #labdata
    WHERE NumResult < 50
    ) b50
  CROSS JOIN (
    SELECT COUNT(*) n
    FROM #labdata
    WHERE NumResult < 53
    ) b53
  CROSS JOIN (
    SELECT COUNT(*) n
    FROM #labdata
    WHERE NumResult < 58
    ) b58
  CROSS JOIN (
    SELECT COUNT(*) n
    FROM #labdata
    WHERE NumResult >= 75
    ) a75    
  WHERE alle.n > 0
  ORDER BY SortOrder, ProfName, a75.n;
    
END
GO

GRANT EXECUTE ON [NDV].[ReportHbA1cByCareGiverSummary] TO [Administrator]
GO

GRANT EXECUTE ON [NDV].[ReportHbA1cByCareGiverSummary] TO [Gruppeleder]
GO