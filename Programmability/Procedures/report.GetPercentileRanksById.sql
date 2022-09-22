SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetPercentileRanksById](@LabCodeId INT )
AS
BEGIN
  WITH LabRankCount
  AS (SELECT ResultId, NumResult, rank() OVER (ORDER BY NumResult) AS RankOrder, count(*) OVER () AS TotalCount
      FROM dbo.LabData
      WHERE (LabCodeId = @LabCodeId)
        AND (NumResult > 0)
  )
  SELECT DISTINCT NumResult, 1. * (RankOrder - 1) / (TotalCount - 1) * 100 AS percentilerank
  FROM LabRankCount
  ORDER BY NumResult
END
GO

GRANT EXECUTE ON [report].[GetPercentileRanksById] TO [FastTrak]
GO