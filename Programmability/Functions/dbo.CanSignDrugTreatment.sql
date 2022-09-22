SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CanSignDrugTreatment]( @UserId INT = NULL ) RETURNS BIT
AS
BEGIN
  DECLARE @RetVal BIT;
  DECLARE @ProfType VARCHAR(3);    
  SET @UserId = ISNULL(@UserId,USER_ID());
  SET @RetVal=0;
  SELECT @ProfType = mp.ProfType FROM UserList ul 
  JOIN dbo.MetaProfession mp ON mp.ProfId=ul.ProfId
  WHERE ul.UserId=@UserId;
  IF @ProfType='LE' 
    SET @RetVal = 1;
  RETURN @RetVal;
END
GO

GRANT EXECUTE ON [dbo].[CanSignDrugTreatment] TO [FastTrak]
GO