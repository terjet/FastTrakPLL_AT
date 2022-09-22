SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugsDispGIG]( @PersonId INTEGER, @OnGoing INTEGER )
AS
BEGIN
  SELECT
    TreatId,StartAt,ATC,DrugName,TreatType,PackType,Strength,StrengthUnit,
    DoseCode,StartReason,StopAt,StopReason,PauseStatus
  FROM dbo.DrugTreatment 
  WHERE PersonId=@PersonId AND ( @OnGoing<>1 OR StopAt>getdate() OR StopAt IS NULL )
  ORDER BY CreatedAt DESC
END
GO