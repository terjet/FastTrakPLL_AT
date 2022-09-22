SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[RetrofitQuantityData]( @MasterItemId INT, @MasterEnumVal INT, @DetailItemId INT, @DetailMinQuantity DECIMAL(18,4) ) AS
BEGIN
  INSERT INTO dbo.ClinDatapoint( EventId, ObsDate,ItemId,Quantity,EnumVal,Locked,LockedAt,LockedBy,TouchId )
    SELECT EventId, ObsDate,@MasterItemId,@MasterEnumVal,@MasterEnumVal,Locked,LockedAt,LockedBy,TouchId 
    FROM dbo.ClinDatapoint WHERE ItemId=@DetailItemId AND Quantity>=@DetailMinQuantity
    AND NOT EventId IN ( SELECT EventId FROM dbo.ClinDatapoint WHERE ItemId=@MasterItemId )
END
GO