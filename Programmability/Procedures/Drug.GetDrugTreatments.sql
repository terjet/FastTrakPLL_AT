SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Drug].[GetDrugTreatments]( @PersonId INTEGER, @OnGoing INTEGER = 0 ) AS
BEGIN
  SELECT dt.*, dp.PauseReason, dp.PauseAuthorizedByName
  FROM dbo.DrugTreatment dt
    JOIN dbo.MetaTreatType mtt ON mtt.TreatType = dt.TreatType
    LEFT JOIN dbo.DrugPause dp ON dp.TreatId = dt.TreatId AND dp.RestartAt IS NULL AND dt.PauseStatus = 1
  WHERE PersonId = @PersonId AND ( ( StopAt > GETDATE() OR StopAt IS NULL OR dt.Seponeringskladd = 1 ) OR @OnGoing = 0 )
  ORDER BY dt.PauseStatus, mtt.SortOrder, dt.StartAt DESC;
END
GO