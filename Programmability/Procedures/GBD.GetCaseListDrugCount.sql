SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListDrugCount]( @StudyId INT ) AS
BEGIN
SELECT *, 'Fast ' + CONVERT(VARCHAR,FastAntall) + ', behov ' + CONVERT(VARCHAR,BehovAntall) + '.' AS InfoText  
FROM 
(
  SELECT v.*, ISNULL(agg_behov.n_behov,0) AS BehovAntall, ISNULL(agg_fast.n_fast,0) AS FastAntall
  FROM dbo.ViewActiveCaseListStub v      
  LEFT OUTER JOIN   
  (
    SELECT PersonId, COUNT(*) AS n_behov
    FROM dbo.OngoingTreatment
    WHERE TreatType = 'B'
    GROUP BY PersonId
  ) agg_behov ON agg_behov.PersonId = v.PersonId
  LEFT OUTER JOIN 
  (
    SELECT PersonId, COUNT(*) AS n_fast
    FROM dbo.OngoingTreatment
    WHERE TreatType IN ('F','U')
    GROUP BY PersonId
  ) agg_fast ON agg_fast.PersonId = v.PersonId
  WHERE v.StudyId=@StudyId
) population
ORDER BY FastAntall DESC, BehovAntall DESC;
END;
GO

GRANT EXECUTE ON [GBD].[GetCaseListDrugCount] TO [Farmasøyt]
GO

GRANT EXECUTE ON [GBD].[GetCaseListDrugCount] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[GetCaseListDrugCount] TO [Lege]
GO