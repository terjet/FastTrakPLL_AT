SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[ProblemList] ( @PersonId INT ) AS 
BEGIN
  SELECT dx.ItemCode, dx.ItemName, dx.ProbDebut, mp.ProbDesc, dx.ProbSummary,
    CHOOSE( dx.ProbActive + 1, 'Andre', 'Aktive' ) AS Title 
  FROM Diagnose.ICD10 dx
  JOIN dbo.MetaProblemType mp ON mp.ProbType = dx.ProbType
  WHERE PersonId = @PersonId
  ORDER BY dx.ProbActive DESC, mp.ProbDesc;
END
GO

GRANT EXECUTE ON [report].[ProblemList] TO [FastTrak]
GO