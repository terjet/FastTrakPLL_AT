SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleLMG]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @LastFormDate DateTime;
  DECLARE @AlertFacet varchar(16);
  DECLARE @ActualLevel INT;
  -- Find the last LMG form
  SELECT @LastFormDate = dbo.GetLastSignedForm( @StudyId, @PersonId, 'LMG' );
  IF @LastFormDate IS NULL 
  BEGIN
    SET @ActualLevel = 2;
    SET @AlertFacet = 'DataMissing';
  END
  ELSE 
  BEGIN
    IF DATEDIFF( DAY, @LastFormDate, GETDATE() ) > 180 
    BEGIN
      SET @ActualLevel = 2;
      SET @AlertFacet = 'DataOld';
    END
    ELSE 
    BEGIN
      SET @ActualLevel = 0;
      SET @AlertFacet = 'DataFound';
    END
  END
  EXEC dbo.AddAlertForDSSRule @StudyId, @PersonId, @ActualLevel, 'LMG', @AlertFacet;
END
GO

GRANT EXECUTE ON [GBD].[RuleLMG] TO [FastTrak]
GO