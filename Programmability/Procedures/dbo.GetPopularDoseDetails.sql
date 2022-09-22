SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetPopularDoseDetails]( @TreatId INT ) AS
BEGIN
  SELECT Dose07,Dose08,Dose13,Dose18,Dose21,Dose23,count(*) AS HitCount 
    FROM DrugDosing dd 
    JOIN DrugTreatment dt ON dd.treatid=dt.treatid 
    JOIN DrugTreatment dt2 ON dt2.ATC=dt.ATC AND dt2.DoseCode=dt.DoseCode AND dt2.TreatPackType=dt.TreatPackType 
  WHERE dt2.TreatId=@TreatId
  GROUP BY Dose07,Dose08,Dose13,Dose18,Dose21,Dose23
  ORDER BY count(*) DESC
END
GO

GRANT EXECUTE ON [dbo].[GetPopularDoseDetails] TO [FastTrak]
GO