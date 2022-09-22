SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[SameData]( @RowId INT, @Quantity DECIMAL(18,4), @DTVal DateTime,@EnumVal INT, @TextVal VARCHAR(MAX) ) RETURNS INT AS 
BEGIN
  DECLARE @RetVal INT;
  DECLARE @OldQuantity DECIMAL(18,4);
  DECLARE @OldDTVal DateTime;
  DECLARE @OldEnumVal INT;
  DECLARE @OldTextVal VARCHAR(MAX);
  SELECT @OldQuantity = Quantity, @OldDTVal = DTVal, @OldEnumVal = EnumVal, @OldTextVal = TextVal
    FROM dbo.ClinDataPoint WHERE RowId=@RowId;
  IF ( @OldQuantity IS NULL ) 
    AND ( @OldTextVal IS NULL ) 
    AND ( @OldDTVal IS NULL ) 
    AND ( @OldEnumVal IS NULL)
      SET @RetVal = -1
  ELSE 
    IF  (( @OldQuantity = @Quantity ) OR ( @OldQuantity IS NULL AND @Quantity IS NULL )) 
    AND (( @OldDTVal = @DTVal ) OR ( @OldDTVal IS NULL AND @DTVal IS NULL ))
    AND (( @OldTextVal = @TextVal ) OR ( @OldTextVal IS NULL AND @TextVal IS NULL )) 
    AND (( @OldEnumVal = @EnumVal ) OR ( @OldEnumVal IS NULL AND @EnumVal IS NULL ))
      SET @RetVal=1
    ELSE
      SET @RetVal= 0;
  RETURN @RetVal;
END
GO