SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[ReportHbA1cGroupPercentiles]( @StudyId INT, @DiaType INT, @ExcludeNew INT ) AS
BEGIN

  SET NOCOUNT ON;
  DECLARE @TotalGroupName VARCHAR(50) = 'Totalt';

  BEGIN TRY
    EXEC NDV.MergeHba1cToLabdata;
  END TRY
  BEGIN CATCH
    SET @TotalGroupName = 'Totalt (NB: Duplikater i skjemadata)';
  END CATCH;

-- Retrieve the latest HbA1c-values first

  SELECT v.PersonId, v.GroupId, v.GroupName, ld.NumResult, diatype.EnumVal
  INTO #labdata
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastLabDataTable( 1058, GETDATE()) ld ON ld.PersonId = v.PersonId
  JOIN dbo.GetLastDateTable( 3323, NULL ) dxdate ON dxdate.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable( 3196, NULL ) diatype ON diatype.PersonId = ld.PersonId
  WHERE ( v.StudyId = @StudyId ) 
    AND ( diatype.EnumVal = @DiaType OR @DiaType IS NULL OR @DiaType < 1 ) 
    AND ( ld.LabDate > dxdate.DTVal + 30.5 * @ExcludeNew );

-- Calculate percentiles per GroupId (doctor)

  SELECT GroupId, GroupName,
    PERCENTILE_DISC(0.10) WITHIN GROUP( ORDER BY NumResult ) OVER ( PARTITION BY GroupId ) AS P10,
    PERCENTILE_DISC(0.50) WITHIN GROUP( ORDER BY NumResult ) OVER ( PARTITION BY GroupId ) AS P50,
    PERCENTILE_DISC(0.90) WITHIN GROUP( ORDER BY NumResult ) OVER ( PARTITION BY GroupId ) AS P90
  INTO #percentiles
  FROM #labdata
  UNION 
  SELECT 999999, @TotalGroupName,
    PERCENTILE_DISC(0.10) WITHIN GROUP( ORDER BY NumResult ) OVER (),
    PERCENTILE_DISC(0.50) WITHIN GROUP( ORDER BY NumResult ) OVER (),
    PERCENTILE_DISC(0.90) WITHIN GROUP( ORDER BY NumResult ) OVER ()
  FROM #labdata;

-- Do standard aggregations

  SELECT * 
  INTO #minmax
  FROM
  (
    SELECT GroupId, GroupName, COUNT(PersonId) AS n, 
        MIN(NumResult) AS MinHbA1c, MAX(NumResult) AS MaxHbA1c, AVG(NumResult) AS MeanHbA1c
      FROM #labdata
      GROUP BY GroupId, GroupName
    UNION
    SELECT 999999, @TotalGroupName, COUNT(PersonId), 
        MIN(NumResult), MAX(NumResult), AVG(NumResult)
      FROM #labdata
  )  agg;

-- Combine the results

  SELECT m.GroupId, m.GroupName, m.n, m.MinHbA1c, p.P10, p.P50, p.P90, m.MaxHbA1c, m.MeanHbA1c
  FROM #minmax m
  JOIN #percentiles p ON p.GroupId = m.GroupId
  ORDER BY m.GroupId;

END
GO

GRANT EXECUTE ON [BDR].[ReportHbA1cGroupPercentiles] TO [FastTrak]
GO