SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugForMultidoseHistoric]( @PersonId INT, @ShowDate DateTime = NULL ) AS
BEGIN
  IF @ShowDate IS NULL SET @ShowDate = GETDATE();
  SELECT
    dt.TreatId, dt.StartAt, dt.DrugName, dbo.GetRxText( dt.TreatId ) AS RxText,
    dt.StopAt, p2.Signature AS StopSign, p1.Signature AS StartSign, dt.PackType, mp.PackDesc,
    mp.SortOrder, mtpg.GroupName,
    dt.TreatType,mt.TreatDesc,
      dbo.ConvertDoseText(dd.Dose07) AS Dose07,
      dbo.ConvertDoseText(dd.Dose08) AS Dose08,
      dbo.ConvertDoseText(dd.Dose13) AS Dose13,
      dbo.ConvertDoseText(dd.Dose18) AS Dose18,
      dbo.ConvertDoseText(dd.Dose21) AS Dose21,
      dbo.ConvertDoseText(dd.Dose23) AS Dose23,
    dt.DrugForm,
    dbo.GetDose24hText( dt.TreatId ) AS Dose24hText,
    dt.Strength, dt.StrengthUnit, dt.Dose24hDD,
    CONVERT( FLOAT, ISNULL( StopAt, @ShowDate + 1 ) - @ShowDate ) AS DaysLeft, 
    dbo.GetDrugPauseStatus( dt.TreatId, @ShowDate ) AS PauseStatus
  FROM dbo.DrugTreatment dt
    JOIN dbo.MetaPackType mp ON mp.PackType = dt.PackType
    JOIN dbo.MetaTreatType mt ON mt.TreatType = dt.TreatType
    LEFT OUTER JOIN dbo.DrugDosing dd ON dd.DoseId = dt.DoseId
    LEFT OUTER JOIN dbo.UserList u1 ON u1.UserId = dt.CreatedBy
    LEFT OUTER JOIN dbo.Person p1 ON p1.PersonId = u1.PersonId
    LEFT OUTER JOIN dbo.UserList u2 ON u2.UserId = dt.StopBy
    LEFT OUTER JOIN dbo.Person p2 ON p2.PersonId = u2.PersonId
    LEFT OUTER JOIN dbo.MetaTreatPackGroup mtpg ON dt.TreatType = mtpg.TreatType AND dt.PackType = mtpg.PackType
  WHERE dt.PersonId=@PersonId
    AND ( ( dt.StopAt IS NULL ) OR ( @ShowDate < dt.StopAt ) )
    AND ( dt.CreatedAt <= @ShowDate ) AND ( dt.Seponeringskladd = 0 )
  ORDER BY mtpg.SortOrder, dt.StartAt;
END
GO