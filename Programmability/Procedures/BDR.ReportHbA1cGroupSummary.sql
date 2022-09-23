SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[ReportHbA1cGroupSummary]( @StudyId INT, @DiaType INT, @ExcludeNew INT ) AS
BEGIN

  SET NOCOUNT ON;
  DECLARE @TotalGroupName VARCHAR(50) = 'Totalt';

  BEGIN TRY
    EXEC NDV.MergeHba1cToLabdata;
  END TRY
  BEGIN CATCH
    SET @TotalGroupName = 'Totalt (NB: Duplikater i skjemadata)';
  END CATCH;
  
  -- Find patients and their latest HbA1c - values
  
-- Retrieve the latest HbA1c-values first

  SELECT v.PersonId, v.GroupId, ld.NumResult
  INTO #labdata
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastLabDataTable( 1058, GETDATE()) ld ON ld.PersonId = v.PersonId
  JOIN dbo.GetLastDateTable( 3323, NULL ) dxdate ON dxdate.PersonId = v.PersonId
  LEFT JOIN dbo.GetLastEnumValuesTable( 3196, NULL ) diatype ON diatype.PersonId = ld.PersonId
  WHERE ( v.StudyId = @StudyId ) 
    AND ( diatype.EnumVal = @DiaType OR @DiaType IS NULL OR @DiaType < 1 ) 
    AND ( ld.LabDate > dxdate.DTVal + 30.5 * @ExcludeNew );

  -- Group by physician and various levels
  
  SELECT alle.GroupId, sg.GroupName, alle.n AS nAll, 
    b50.n AS n50, b53.n AS n53, b58.n AS n58, a75.n AS n75, 
    100.0 * b50.n / alle.n AS b50p, 
    100.0 * b53.n / alle.n AS b53p, 
    100.0 * b58.n / alle.n AS b58p, 
    100.0 * a75.n / alle.n AS a75p
  FROM (
    SELECT GroupId, COUNT(*) n
    FROM #labdata
    GROUP BY GroupId
    ) alle
  LEFT JOIN (
    SELECT GroupId, COUNT(*) n
    FROM #labdata
    WHERE NumResult < 50
    GROUP BY GroupId
    ) b50 ON b50.GroupId = alle.GroupId
  LEFT JOIN (
    SELECT GroupId, COUNT(*) n
    FROM #labdata
    WHERE NumResult < 53
    GROUP BY GroupId
    ) b53 ON b53.GroupId = alle.GroupId
  LEFT JOIN (
    SELECT GroupId, COUNT(*) n
    FROM #labdata
    WHERE NumResult < 58
    GROUP BY GroupId
    ) b58 ON b58.GroupId = alle.GroupId
  LEFT JOIN (
    SELECT GroupId, COUNT(*) n
    FROM #labdata
    WHERE NumResult >= 75
    GROUP BY GroupId
    ) a75 ON a75.GroupId = alle.GroupId
  JOIN dbo.StudyGroup sg ON sg.StudyId = @StudyId
    AND sg.GroupId = alle.GroupId AND sg.GroupActive = 1

UNION 

-- Add a row for all groups put together

  SELECT 999999, @TotalGroupName, alle.n, b50.n, b53.n, b58.n, a75.n, 
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
    ) a75;   
    
END
GO

GRANT EXECUTE ON [BDR].[ReportHbA1cGroupSummary] TO [FastTrak]
GO