SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddDrugFromTemplate]( @PersonId INTEGER, @TemplateId INTEGER, @StartAt DateTime = NULL )
AS
BEGIN
  DECLARE @ATC VARCHAR(7);
  DECLARE @DrugName VARCHAR(64);  
  DECLARE @DrugForm VARCHAR(64);
  DECLARE @Strength DECIMAL(12,4);
  DECLARE @TreatId INTEGER;      
  DECLARE @TreatType CHAR(1);
  DECLARE @PackType CHAR(1);
  DECLARE @CanModifyDrugTreatment BIT;
  DECLARE @ErrMsg VARCHAR(512);

  SET @CanModifyDrugTreatment = 1;

  EXEC dbo.CanModifyDrugTreatment  null, @CanModifyDrugTreatment OUTPUT, @ErrMsg OUTPUT;
  IF  @CanModifyDrugTreatment = 0
  BEGIN
    RAISERROR( @ErrMsg, 16, 1 );
    RETURN -200;
  END;

  IF @StartAt IS NULL SET @StartAt=getdate();
  
  SELECT @ATC = ATC, @Strength=Strength,@DrugForm = DrugForm FROM dbo.DrugTemplate WHERE TemplateId=@TemplateId;
  
  SELECT @DrugName=DrugName FROM dbo.DrugTreatment WHERE PersonId=@PersonId AND StopAt IS NULL AND ATC=@ATC; 
  
  IF @DrugName IS NULL
  BEGIN  
    INSERT INTO dbo.DrugTreatment 
      (PersonId,ATC,DrugName,DrugForm,Strength,StrengthUnit,StartAt,StartReason,DoseCode )
  
    SELECT @PersonId,ATC,DrugName,DrugForm,Strength,StrengthUnit,@StartAt,StartReason,DoseCode
      FROM dbo.DrugTemplate 
     WHERE TemplateId=@TemplateId;
    
    SET @TreatId=SCOPE_IDENTITY();
    
    /* Get TreatPack info */
    SELECT TOP 1 TreatType,PackType,count(*) AS HitCount INTO #MostPopularDosing 
      FROM dbo.DrugTreatment 
     WHERE ATC=@ATC AND DrugForm=@DrugForm AND Strength=@Strength 
  GROUP BY TreatType,PackType ORDER BY count(*) DESC;          
    
    SELECT @TreatType=TreatType,@PackType=PackType FROM #MostPopularDosing;
    
    /* Update with most popular TreatPack */
    UPDATE dbo.DrugTreatment SET TreatType=@TreatType,PackType=@PackType WHERE TreatId=@TreatId;
    SELECT @TreatId AS TreatId;
  END
  ELSE
  BEGIN         
    SET @ErrMsg = dbo.GetTextItem( 'AddDrugFromTemplate','DrugExists'); 
    RAISERROR( @ErrMsg, 16,1, @DrugName, @ATC );
  END         
END
GO