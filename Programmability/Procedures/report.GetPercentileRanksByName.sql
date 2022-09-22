SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetPercentileRanksByName]( @LabVarName VARCHAR(24) )
AS
BEGIN
  WITH LabRankCount
  AS (SELECT ld.ResultId, ld.NumResult, rank() OVER (ORDER BY ld.NumResult) AS RankOrder, count(*) OVER () AS TotalCount
      FROM dbo.LabData ld
        JOIN dbo.LabCode lc
          ON lc.LabCodeId = ld.LabCodeId
      WHERE (lc.VarName = @LabVarName)
        AND (ld.NumResult > 0)
  )
  SELECT DISTINCT NumResult, 1. * (RankOrder - 1) / (TotalCount - 1) * 100 AS percentilerank
  FROM LabRankCount
  ORDER BY NumResult
END
GO