SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetRxTextSuggestions]( @TreatId INT, @LookBack INT = 3650, @MinCount INT = 0 ) AS
BEGIN
  SELECT ROW_NUMBER() OVER ( ORDER BY COUNT(*) DESC ),LTRIM(SUBSTRING(pre.RxText,1,1024)), NULL,COUNT(*)
  FROM DrugTreatment dt JOIN DrugTreatment dtold 
  ON dtold.ATC=dt.ATC AND dtold.TreatPackType=dt.TreatPackType AND dtold.DoseCode=dt.DoseCode
    AND ISNULL(dtold.Dose24hCount,0) = ISNULL(dt.Dose24hCount,0)
    AND ISNULL(dtold.Strength,0) = ISNULL(dt.Strength,0)
    AND dtold.DrugForm = dt.DrugForm
  JOIN DrugPrescription pre ON pre.TreatId=dtold.TreatId  
  WHERE dtold.CreatedAt > GETDATE()- @LookBack
    AND DATALENGTH( pre.RxText ) > 5
    AND dt.TreatId=@TreatId
  GROUP BY LTRIM(SUBSTRING(pre.RxText,1,1024))
  HAVING COUNT(*) >= @MinCount
  ORDER BY COUNT(*) DESC
END
GO

GRANT EXECUTE ON [dbo].[GetRxTextSuggestions] TO [FastTrak]
GO