SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RuleGFR]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @GFR DECIMAL(5,1);
  DECLARE @AlertLevel INT;
  DECLARE @Facet varchar(16);
  DECLARE @MsgStr varchar(512);
  DECLARE @HeadStr varchar(64);
  /* Todo: Return error message from CockgroftGault for missing data */
  SET @GFR = dbo.GetMDRD( @PersonId, getdate() );
  IF ( @GFR IS NULL ) OR ( @GFR <= 0 ) BEGIN
    SET @AlertLevel = 2;
    SET @Facet = 'DataMissing'
  END
  ELSE BEGIN
    IF @GFR < 30 BEGIN
      SET @AlertLevel=3;
      SET @Facet='RiskHigh';
    END
    ELSE IF @GFR < 45 BEGIN
      SET @AlertLevel=2;
      SET @Facet='RiskMedium';
    END
    ELSE IF @GFR < 60 BEGIN
      SET @AlertLevel=1;
      SET @Facet='RiskLow';
    END
    ELSE BEGIN
      SET @AlertLevel=0;
      SET @Facet = 'DataFound';
    END;
  END;
  SET @MsgStr=dbo.GetTextItem('GFR',@Facet);
  SET @HeadStr=dbo.GetTextItem('GFR',@Facet+'.Header');
  IF CHARINDEX( '@GFR',@MsgStr ) > 1 SET @MsgStr=REPLACE(@MsgStr,'@GFR',CONVERT(VARCHAR,@GFR));
  IF CHARINDEX( '@Formula',@MsgStr) > 1 SET @MsgStr=REPLACE(@MsgStr,'@Formula','MDRD');
  EXEC AddAlertForPerson @StudyId,@PersonId,@AlertLevel,'GFR',@Facet,@HeadStr,@MsgStr
END;
GO