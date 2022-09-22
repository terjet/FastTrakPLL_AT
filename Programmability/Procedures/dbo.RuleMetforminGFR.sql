SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RuleMetforminGFR]( @StudyId INT, @PersonId INT )
AS
BEGIN
  DECLARE @CalcAt DateTime;
  DECLARE @HeaderText VARCHAR(64);
  DECLARE @MsgText VARCHAR(512);
  DECLARE @AlertFacet VARCHAR(16);
  DECLARE @AlertLevel INT;
  DECLARE @GFR INT;
  SET @CalcAt = getdate();
  IF dbo.GetDrugUse( @PersonId, 'A10BA02', @CalcAt ) = 1
  BEGIN
    SET @GFR = dbo.GetMDRD( @PersonId, @CalcAt );
    IF @GFR IS NULL
    BEGIN
      SET @HeaderText = 'Metformin + ukjent GFR'
      SET @MsgText = 'Alle som bruker metformin bør måle GFR regelmessig.';
      SET @AlertLevel= 3;
      SET @AlertFacet = 'DataMissing';
    END
    ELSE IF @GFR < 60
    BEGIN
      SET @HeaderText = 'Metformin + lav GFR';
      SET @MsgText = ( 'OBS eGFR = ' + CONVERT(VARCHAR,@GFR) + ' mL/min/1.73m2. Vurder å seponere metformin.' );
      IF @GFR < 60
      BEGIN
        SET @AlertFacet = 'RiskHigh';
        IF @GFR < 30
        BEGIN
          SET @AlertLevel = 4;
            IF @GFR < 15
              SET @MsgText = @MsgText + ' Nyresykdom grad 4, betydelig nedsatt GFR. '
          ELSE
              SET @MsgText = @MsgText + ' Nyresykdom grad 5, nyresvikt. ';
          END
        ELSE
        BEGIN
          -- Mellom 30 og 60
          SET @AlertLevel = 3;
       SET @MsgText = @MsgText + ' Nyresykdom grad 3, moderat redusert GFR. ';
        END;
      END;
    END
    ELSE
    BEGIN
     SET @HeaderText = 'Metformin + normal GFR';
     SET @MsgText = ( 'eGFR = ' + CONVERT(VARCHAR,@GFR) + ' mL/min/1.73m2' );
     SET @AlertFacet = 'RiskLow';
     SET @AlertLevel = 0;
    END
  END
  ELSE
  BEGIN
    SET @HeaderText = 'Ikke metformin';
    SET @MsgText = 'Bruker ikke metformin, vurdering av GFR utelatt.';
    SET @AlertFacet = 'Exclude';
    SET @AlertLevel = 0;
  END;
  EXEC AddAlertForPerson @StudyId,@PersonId,@AlertLevel,'METFORMGFR',@AlertFacet,@HeaderText,@MsgText;
END
GO