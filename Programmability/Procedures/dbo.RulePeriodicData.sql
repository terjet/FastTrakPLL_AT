SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RulePeriodicData]( @StudyId INT, @PersonId INT, @VarName VARCHAR(64), @DaysBetween INT, @MissingLevel tinyint ) AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @RuleName VARCHAR(24);
  DECLARE @LastDate DateTime; 
  DECLARE @LastEventNum INT; 
  DECLARE @AlertLevel tinyint; 
  DECLARE @AlertFacet VARCHAR(16);    
  DECLARE @ItemId INT;
  SET @RuleName = SUBSTRING( @VarName, 1, 20 ) + CONVERT(VARCHAR,@DaysBetween) + 'D';
  SELECT @ItemId = ItemId FROM dbo.MetaItem WHERE VarName = @VarName;
  /* Find latest data from ClinDataPoint */
  SELECT TOP 1 @LastEventNum = ce.EventNum 
  FROM dbo.ClinDataPoint cdp WITH (NOLOCK) 
  JOIN dbo.ClinEvent ce WITH (NOLOCK) ON ce.EventId = cdp.EventId
  WHERE ce.StudyId = @StudyId AND ce.PersonId = @PersonId AND cdp.ItemId = @ItemId AND ( cdp.Quantity >= 0 )
  ORDER BY ce.EventNum DESC;
  SET @LastDate = dbo.FnEventNumToDate( @LastEventNum );
  /* Evaluate */
  IF @LastEventNum IS NULL BEGIN
    SET @AlertFacet = 'DataMissing';
    SET @AlertLevel = @MissingLEvel;
  END
  ELSE IF @LastDate < GETDATE() - @DaysBetween BEGIN
    SET @AlertFacet = 'DataOld';
    SET @AlertLevel = @MissingLevel;
  END
  ELSE BEGIN
    SET @AlertFacet = 'DataFound';
    SET @AlertLevel = 0;
  END;
  EXEC dbo.AddAlertForDSSRule @StudyId,@PersonId,@AlertLevel,@RuleName,@AlertFacet;
END
GO

GRANT EXECUTE ON [dbo].[RulePeriodicData] TO [FastTrak]
GO