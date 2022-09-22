SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RulePeriodicData]( @StudyId INT, @PersonId INT, @VarName VarChar(24), 
  @DaysBetween INT, @MissingLevel tinyint ) AS
BEGIN
  DECLARE @RuleName VARCHAR(24);
  DECLARE @LabDate DateTime;
  DECLARE @ClinDate DateTime;
  DECLARE @LastDate DateTime; 
  DECLARE @AlertLevel tinyint; 
  DECLARE @AlertFacet VARCHAR(16);    
  SET @RuleName = @VarName + CONVERT(VARCHAR,@DaysBetween) + 'D';
  /* Find latest data from lab table */
  SELECT @LabDate = MAX(LabDate) FROM LabData ld JOIN LabCode lc
    ON lc.LabCodeId=ld.LabCodeId AND lc.VarName=@VarName                      
  WHERE ld.PersonId=@PersonId AND ( ld.NumResult >= 0 );
  /* Find latest data from ClinData */
  SELECT @ClinDate = MAX(ce.EventTime) FROM ClinObservation co JOIN ClinEvent ce on ce.EventId=co.EventId 
  WHERE co.VarName=@VarName AND ce.PersonId=@PersonId AND ( co.Quantity >= 0 );
  /* Consolidate into @LastDate */
  SET @ClinDate = ISNULL(@ClinDate,0);
  SET @LabDate = ISNULL(@LabDate,0);
  IF @LabDate > @ClinDate SET @LastDate=@LabDate ELSE SET @LastDate=@ClinDate;
  /* Evaluate */
  IF @LastDate = 0 BEGIN
    SET @AlertFacet = 'DataMissing';
    SET @AlertLevel = @MissingLEvel;
  END
  ELSE IF @LastDate < getdate() - @DaysBetween BEGIN
    SET @AlertFacet = 'DataOld';
    SET @AlertLevel = @MissingLevel;
  END
  ELSE BEGIN
    SET @AlertFacet = 'DataFound';
    SET @AlertLevel = 0;
  END;
  EXEC AddAlertForDSSRule @StudyId,@PersonId,@AlertLevel,@RuleName,@AlertFacet
END
GO

GRANT EXECUTE ON [dbo].[RulePeriodicData] TO [FastTrak]
GO