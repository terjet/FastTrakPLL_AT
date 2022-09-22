SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RulePeriodicForm]( @StudyId INT, @PersonId INT, @FormName VarChar(24),
 @DaysBetween INT, @AlertLevel tinyint ) AS
BEGIN
  DECLARE @LastFormDate DateTime;
  DECLARE @DaysAgo DECIMAL(6,1);
  DECLARE @AlertFacet varchar(16);
  DECLARE @ActualLevel INT;
  SELECT @LastFormDate = dbo.GetLastCompleteForm( @StudyId,@PersonId,@FormName );
  IF @LastFormDate IS NULL BEGIN
    SET @ActualLevel = @AlertLevel;
    SET @AlertFacet = 'DataMissing';
  END
  ELSE BEGIN
    SET @DaysAgo=CONVERT(FLOAT,GetDate())-CONVERT(FLOAT,@LastFormDate);
    IF @DaysAgo>@DaysBetween BEGIN
      SET @ActualLevel = @AlertLevel;
      SET @AlertFacet = 'DataOld';
    END
    ELSE BEGIN
      SET @ActualLevel = 0;
      SET @AlertFacet = 'DataFound';
    END
  END
  EXEC AddAlertForDSSRule @StudyId,@PersonId,@ActualLevel,@FormName,@AlertFacet
END;
GO