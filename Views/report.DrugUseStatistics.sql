SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [report].[DrugUseStatistics]  
AS
SELECT ac.StudyId,k.AtcCode,k.AtcName,
  COUNT(*) as n,
  CAST(100.00 * count(*) /(select count(distinct personid) from dbo.Person )
    AS DECIMAL(9,2)) as pct,
    
  MIN(Dose24hDD) as [MinDD],
  CAST( AVG(Dose24hDD) AS DECIMAL(9,2) ) as [AvgDD],
  MAX(Dose24hDD) as [MaxDD],

  MIN(Dose24hCount) AS MinN,
  CAST( AVG(Dose24hCount) AS DECIMAL(9,2) ) AS AvgN,
  MAX(Dose24hCount) AS MaxN,

  VAR(Dose24hDD) AS VarDD,
  VARP(Dose24hDD) AS VarPDD,
  STDEV(Dose24hDD) AS StdDD,
  STDEVP(Dose24hDD) AS StdPDD,

  VAR(Dose24hCount) AS VarN,
  VARP(Dose24hCount) AS VarPN,
  STDEV(Dose24hCount) AS StdN,
  STDEVP(Dose24hCount) AS StdPN

FROM dbo.DrugTreatment dt
JOIN dbo.AllActiveCases ac on ac.PersonId=dt.PersonId
JOIN dbo.KBAtcIndex k ON k.AtcCode=dt.ATC
  WHERE( StopAt IS NULL ) OR ( StopAt > getdate())
 AND ( NOT ATC IS NULL )
 AND ( NOT Dose24hDD IS NULL )
 AND ( NOT Dose24hCount IS NULL )
GROUP BY ac.StudyId,k.AtcCode,k.AtcName
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [report].[DrugUseStatistics] TO [public]
GO