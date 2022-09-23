SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[Bestillingsliste] AS
BEGIN
  SELECT a.ATCCode, a.ATCName, dbo.GetFirstWord( dt.DrugName ) as DrugName, dt.DrugForm, NULLIF(dt.Strength,0) AS Strength, dt.StrengthUnit,
     count(*) as PasAnt, NULLIF( sum(dt.Dose24hCount),0) AS Ant24h,CONVERT( INT, NULLIF( sum(dt.Dose24hCount)*14,0) ) AS Ant14d
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.OngoingTreatment dt ON dt.PersonId=v.PersonId
  JOIN dbo.KBATCIndex a ON dt.ATC=a.ATCCode
  JOIN dbo.MetaTreatType mt ON mt.TreatType=dt.TreatType
  JOIN dbo.MetaPackType mp ON mp.PackType=dt.PackType
  WHERE dt.PackType <> 'M'
  GROUP BY a.ATCCode, a.ATCName,dbo.GetFirstWord( dt.DrugName ),dt.DrugForm,dt.Strength,dt.StrengthUnit 
  ORDER BY a.ATCCode, Strength
END
GO

GRANT EXECUTE ON [GBD].[Bestillingsliste] TO [Farmasøyt]
GO

GRANT EXECUTE ON [GBD].[Bestillingsliste] TO [FastTrak]
GO

GRANT EXECUTE ON [GBD].[Bestillingsliste] TO [Gruppeleder]
GO

GRANT EXECUTE ON [GBD].[Bestillingsliste] TO [Lege]
GO

GRANT EXECUTE ON [GBD].[Bestillingsliste] TO [Sykepleier]
GO

GRANT EXECUTE ON [GBD].[Bestillingsliste] TO [Vernepleier]
GO