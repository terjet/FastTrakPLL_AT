SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[ReportHbA1cByCareGiver]( @StudyId INT, @DiaType INT, @MinCount INT ) AS
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

  SELECT v.PersonId, sv.UserId, sv.ProfName, sv.ReverseName, ld.NumResult, diatype.EnumVal
  INTO #labdata
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastLabDataTable( 1058, GETDATE()) ld ON ld.PersonId = v.PersonId
  JOIN #LastStudyVisit sv ON sv.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable( 3196, NULL ) diatype ON diatype.PersonId = ld.PersonId
  WHERE ( v.StudyId = @StudyId ) 
    AND ( diatype.EnumVal = @DiaType OR @DiaType IS NULL OR @DiaType < 1 ); 


-- Calculate percentiles per GroupId (doctor/nurse)

  SELECT UserId, ProfName, ReverseName,
    PERCENTILE_DISC(0.10) WITHIN GROUP( ORDER BY NumResult ) OVER ( PARTITION BY UserId) AS P10,
    PERCENTILE_DISC(0.50) WITHIN GROUP( ORDER BY NumResult ) OVER ( PARTITION BY UserId ) AS P50,
    PERCENTILE_DISC(0.90) WITHIN GROUP( ORDER BY NumResult ) OVER ( PARTITION BY UserId ) AS P90
  INTO #percentiles
  FROM #labdata
  UNION 
  SELECT 999999, @TotalGroupName, @TotalGroupName,
    PERCENTILE_DISC(0.10) WITHIN GROUP( ORDER BY NumResult ) OVER (),
    PERCENTILE_DISC(0.50) WITHIN GROUP( ORDER BY NumResult ) OVER (),
    PERCENTILE_DISC(0.90) WITHIN GROUP( ORDER BY NumResult ) OVER ()
  FROM #labdata;

-- Do standard aggregations

  SELECT * 
  INTO #minmax
  FROM
  (
    SELECT 1 AS SortOrder, UserId, COUNT(PersonId) AS n, 
        MIN(NumResult) AS MinHbA1c, MAX(NumResult) AS MaxHbA1c, AVG(NumResult) AS MeanHbA1c
      FROM #labdata
      GROUP BY UserId
    UNION
    SELECT 2, 999999, COUNT(PersonId), 
        MIN(NumResult), MAX(NumResult), AVG(NumResult)
      FROM #labdata
  )  agg;

-- Combine the results

  SELECT m.UserId AS GroupId, p.ReverseName AS GroupName, p.ProfName, m.n, m.MinHbA1c, p.P10, p.P50, p.P90, m.MaxHbA1c, m.MeanHbA1c
  FROM #minmax m
  JOIN #percentiles p ON p.UserId = m.UserId
  WHERE m.n >= @MinCount
  ORDER BY m.SortOrder, p.ProfName, m.MeanHbA1c

END
GO

GRANT EXECUTE ON [NDV].[ReportHbA1cByCareGiver] TO [Administrator]
GO

GRANT EXECUTE ON [NDV].[ReportHbA1cByCareGiver] TO [Gruppeleder]
GO