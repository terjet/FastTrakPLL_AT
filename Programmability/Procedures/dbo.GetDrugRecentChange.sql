SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDrugRecentChange]( @PersonId INT , @DaysAgo INT = 14, @ShowDate DateTime = NULL )
AS 
BEGIN
  SET NOCOUNT ON;
  IF @ShowDate IS NULL SET @ShowDate = getdate();
  SELECT
    dt.TreatId,dt.StartAt,p1.Signature as StartSign,
    dt.DrugName,dt.DrugForm,dt.Strength,dt.StrengthUnit,dt.StopReason,
    dt.StopAt,p2.Signature as StopSign,
    CONVERT(FLOAT,@ShowDate-dt.StopAt) as DaysAgo
  FROM DrugTreatment dt
    LEFT OUTER JOIN dbo.UserList u1 on u1.UserId=dt.CreatedBy
    LEFT OUTER JOIN dbo.Person p1 on p1.PersonId=u1.PersonId
    LEFT OUTER JOIN dbo.UserList u2 on u2.UserId=dt.StopBy
    LEFT OUTER JOIN dbo.Person p2 on p2.PersonId=u2.PersonId
  WHERE (dt.PersonId=@PersonId) AND (NOT dt.StopAt IS NULL)
   AND (@ShowDate > dt.StopAt ) 
   AND (@ShowDate < dt.StopAt + @DaysAgo)
   AND ( dt.CreatedAt <= @ShowDate )
  ORDER BY dt.StopAt DESC
END
GO