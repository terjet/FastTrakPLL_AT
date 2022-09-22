SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetRxText]( @TreatId INT ) RETURNS VarChar(255) AS
BEGIN
  DECLARE @RetVal VarChar(255);
  DECLARE @RxText VarChar(255); 
  DECLARE @StartReason VarChar(255);   
  DECLARE @DoseCode VarChar(24);     
  DECLARE @TreatPackType CHAR(2);
  SELECT @RxText = ISNULL(RxText,''), @StartReason = ISNULL(StartReason,''), @DoseCode = ISNULL(DoseCode,''), @TreatPackType = TreatPackType 
    FROM dbo.DrugTreatment WHERE TreatId = @TreatId;                                   
  IF @StartReason <> '' SET @RetVal = @StartReason;
  IF @RxText <> '' AND @StartReason <> ''  SET @RetVal = @RetVal + '. ';
  SET @RetVal = @RetVal + @RxText;
  IF @TreatPackType = 'BO' SET @RetVal = @DoseCode + '. ' + @RetVal;
  RETURN @RetVal;
END
GO