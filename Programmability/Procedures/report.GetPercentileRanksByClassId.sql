SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetPercentileRanksByClassId](@LabClassId INT ) AS
BEGIN
  WITH LabRankCount
  AS (SELECT ResultId, NumResult, RANK() OVER (ORDER BY NumResult) AS RankOrder, COUNT(*) OVER () AS TotalCount
      FROM dbo.LabData ld
	  JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
      WHERE (lc.LabClassId = @LabClassId)
        AND (NumResult > 0)
  )
  SELECT DISTINCT NumResult, 1. * (RankOrder - 1) / (TotalCount - 1) * 100 AS percentilerank
  FROM LabRankCount
  ORDER BY NumResult
END
GO