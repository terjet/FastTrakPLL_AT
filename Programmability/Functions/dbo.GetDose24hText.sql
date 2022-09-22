SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetDose24hText]( @TreatId INT ) RETURNS VarChar(255) AS
BEGIN
  DECLARE @RetVal VarChar(255);
  DECLARE @Dose24HDD DECIMAL(12,2);   
  DECLARE @StrengthUnit VARCHAR(24);
  SELECT @StrengthUnit=ISNULL(StrengthUnit,''),@Dose24hDD=Dose24hDD 
    FROM DrugTreatment WHERE TreatId=@TreatId;
  IF CHARINDEX('/',@StrengthUnit) > 1 SET @StrengthUnit=SUBSTRING(@StrengthUnit,1,CHARINDEX('/',@StrengthUnit)-1);
  IF @StrengthUnit='%' 
    SET @RetVal = ''
  ELSE
    SET @RetVal = CONVERT(VARCHAR,@Dose24hDD) + ' ' + @StrengthUnit;
  IF @Dose24hDD = 0 SET @RetVal = 'n/a';
  RETURN @RetVal;
END
GO