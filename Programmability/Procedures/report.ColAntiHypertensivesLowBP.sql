SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[ColAntiHypertensivesLowBP]( @LowBpThreshold INT ) AS
BEGIN
  SELECT rx.PersonId, mi.VarName, sbp.Quantity AS DpValue, sbp.EventTime, rx.MaxTreatId AS TreatId 
  FROM 
  ( 
    SELECT PersonId,MAX(TreatId) AS MaxTreatId 
    FROM dbo.OngoingTreatment 
    WHERE ( ATC LIKE 'C07%' OR ATC LIKE 'C09%' OR ATC LIKE 'C08%' OR ATC LIKE 'C02%' OR ATC LIKE 'C03%' ) 
       GROUP BY PersonId 
  ) rx 
  JOIN dbo.GetLastQuantityTable( 3556, NULL ) sbp ON rx.PersonId = sbp.PersonId 
  JOIN dbo.MetaItem mi ON mi.ItemId = 3556 
  WHERE sbp.Quantity < @LowBpThreshold;
END
GO

GRANT EXECUTE ON [report].[ColAntiHypertensivesLowBP] TO [QuickStat]
GO