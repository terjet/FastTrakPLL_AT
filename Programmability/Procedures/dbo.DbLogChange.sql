SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DbLogChange]( @DbVer INT, @ChangeType VARCHAR(12), @Details VARCHAR(MAX) )
AS
BEGIN  
  DECLARE @OrderNumber INT;
  SELECT @OrderNumber = ISNULL(MAX(OrderNumber),0) FROM DbUpgradeChanges WHERE DbVer=@DbVer;
  INSERT INTO DbUpgradeChanges ( DbVer,OrderNumber,ChangeType,Details) VALUES( @DbVer,@OrderNumber+1,@ChangeType,@Details )
END
GO

GRANT EXECUTE ON [dbo].[DbLogChange] TO [FastTrak]
GO