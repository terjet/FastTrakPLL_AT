SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugPauses]( @PersonId INT ) AS
BEGIN
  SELECT dp.PauseId, dt.ATC, dt.DrugName, dt.DrugForm, dt.Strength, dt.StrengthUnit,
    dp.PauseReason, 
    dp.PausedAt, dp.PausedBy, pp.Signature AS PausedBySign, dp.PauseAuthorizedByName,  
    dp.RestartAt, dp.RestartBy, pr.Signature AS RestartBySign,
    dt.StopAt, dt.StopBy, ps.Signature as StopBySign 
  FROM dbo.DrugPause dp
  JOIN dbo.DrugTreatment dt ON dp.TreatId = dt.TreatId                   
  JOIN dbo.UserList up ON up.UserId = dp.PausedBy
  LEFT OUTER JOIN dbo.UserList ur ON ur.UserId = dp.RestartBy
  LEFT OUTER JOIN dbo.UserList us ON us.UserId = dt.StopBy
  LEFT OUTER JOIN dbo.Person pp ON pp.PersonId = up.PersonId
  LEFT OUTER JOIN dbo.Person pr ON pr.PersonId = ur.PersonId
  LEFT OUTER JOIN dbo.Person ps ON ps.PersonId = us.PersonId
  WHERE dt.PersonId = @PersonId;
END
GO