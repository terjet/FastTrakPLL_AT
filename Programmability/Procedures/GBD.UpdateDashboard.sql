SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[UpdateDashboard]( @StartAt DateTime = NULL, @DayOfMonth INT = 1 ) AS
BEGIN
  DECLARE @ThisDate DateTime;                                     
  DECLARE @StudyId INT;
  SELECT @StudyId = StudyId FROM dbo.Study WHERE StudName = 'GBD';
  IF @StartAt IS NULL
  BEGIN            
    -- WEIGHT.AGE is used as proxy for last data
    SELECT @StartAt = MAX(StatusDate) from Dash.PersonData WHERE QIName = 'WEIGHT.AGE' AND StudyId=@StudyId AND DatePart( day, StatusDate)= @DayOfMonth;
    IF @StartAt IS NULL SET @StartAt ='2009-12-01';
    SET @StartAt = DATEADD( month, 1, @StartAt ); 
  END;
  SET @ThisDate = @StartAt; 
  WHILE ( @ThisDate < getdate() ) 
  BEGIN                                             
    EXEC Dash.UpdateDaysSinceMeasure @StudyId,@ThisDate,'HULTEN_SCORE'
    EXEC Dash.UpdateDaysSinceMeasure @StudyId,@ThisDate,'WEIGHT'
    EXEC Dash.UpdateDaysSinceMeasure @StudyId,@ThisDate,'ICD10_F03'
    EXEC Dash.UpdateDaysSinceMeasure @StudyId,@ThisDate,'SBP_UNSPEC'
    EXEC Dash.UpdateDrugStatus @StudyId, @ThisDate,'A10%'
    EXEC Dash.UpdateDrugStatus @StudyId, @ThisDate,'B01AA03'
    EXEC Dash.UpdateDrugStatus @StudyId, @ThisDate,'C01AA%'
    EXEC Dash.UpdateDrugStatus @StudyId, @ThisDate,'C09%'
    EXEC Dash.UpdateDrugStatus @StudyId, @ThisDate,'J01%'
    EXEC Dash.UpdateDrugStatus @StudyId, @ThisDate,'H03AA01'
    EXEC Dash.UpdateDrugStatus @StudyId, @ThisDate,'N05A%'
    EXEC Dash.UpdateDrugStatus @StudyId, @ThisDate,'N05C%'
    EXEC Dash.UpdateDrugStatus @StudyId, @ThisDate,'N02A%'
    EXEC Dash.UpdateDrugStatus @StudyId, @ThisDate,'J01XX%'
    SET @ThisDate = DATEADD( month, 1, @ThisDate ); 
  END 
  SELECT @StartAt AS StartAt, @ThisDate AS StopAt;
END
GO