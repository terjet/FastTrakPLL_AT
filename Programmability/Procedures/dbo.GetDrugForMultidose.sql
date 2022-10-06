SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugForMultidose]( @PersonId INT, @ShowDate DATETIME = NULL ) AS
BEGIN
  IF @ShowDate IS NULL
    SET @ShowDate = GETDATE();
  SELECT dt.TreatId, dt.StartAt, dt.DrugName, dbo.GetRxText(dt.TreatId) AS RxText,
    dt.StopAt,
    p2.Signature AS StopSign, p1.Signature AS StartSign, p3.Signature AS CreateSign,
    dt.PackType, mp.PackDesc,
    mp.SortOrder, mtpg.GroupName,
    dt.TreatType, mt.TreatDesc,
    dbo.ConvertDoseHourText(dd.Dose07, 7, dd.DoseHour) AS Dose07,
    dbo.ConvertDoseHourText(dd.Dose08, 8, dd.DoseHour) AS Dose08,
    dbo.ConvertDoseHourText(dd.Dose13, 13, dd.DoseHour) AS Dose13,
    dbo.ConvertDoseHourText(dd.Dose18, 18, dd.DoseHour) AS Dose18,
    dbo.ConvertDoseHourText(dd.Dose21, 21, dd.DoseHour) AS Dose21,
    dbo.ConvertDoseHourText(dd.Dose23, 23, dd.DoseHour) AS Dose23,
    dt.DrugForm,
    dbo.GetDose24hText(dt.TreatId) AS Dose24hText,
    dt.Strength, dt.StrengthUnit, dt.Dose24hDD,
    CONVERT(FLOAT, ISNULL(dt.StopAt, @ShowDate + 1) - @ShowDate) AS DaysLeft, dt.PauseStatus,
    dp.PauseReason
  FROM dbo.DrugTreatment dt
  JOIN dbo.MetaPackType mp ON mp.PackType = dt.PackType
  JOIN dbo.MetaTreatType mt ON mt.TreatType = dt.TreatType
  LEFT OUTER JOIN dbo.DrugDosing dd ON dd.DoseId = dt.DoseId  
  LEFT OUTER JOIN dbo.DrugPause dp ON dp.TreatId = dt.TreatId AND dp.RestartAt IS NULL AND dt.PauseStatus = 1 
  LEFT OUTER JOIN dbo.UserList u1 ON u1.UserId = dt.SignedBy
  LEFT OUTER JOIN dbo.Person p1 ON p1.PersonId = u1.PersonId
  LEFT OUTER JOIN dbo.UserList u2 ON u2.UserId = dt.StopBy
  LEFT OUTER JOIN dbo.Person p2 ON p2.PersonId = u2.PersonId
  LEFT OUTER JOIN dbo.UserList u3 ON u3.UserId = dt.CreatedBy
  LEFT OUTER JOIN dbo.Person p3 ON p3.PersonId = u3.PersonId
  LEFT OUTER JOIN dbo.MetaTreatPackGroup mtpg ON dt.TreatType = mtpg.TreatType AND dt.PackType = mtpg.PackType
  WHERE dt.PersonId = @PersonId
    AND ((dt.StopAt IS NULL) OR ((@ShowDate < dt.StopAt) AND (dt.StartAt < dt.StopAt)))
    AND (dt.CreatedAt <= @ShowDate)
  ORDER BY mtpg.SortOrder, dt.StartAt;
END
GO

GRANT EXECUTE ON [dbo].[GetDrugForMultidose] TO [FastTrak]
GO