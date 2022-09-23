SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleInfectionForm]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @LastJ01Date DateTime;
  DECLARE @LastFormDate DateTime;
  DECLARE @MsgText VARCHAR(512);
  DECLARE @FormDateText VARCHAR(24);
  DECLARE @DrugName VARCHAR(64);
  -- Find ongoing or recently started antibiotic/antiparasitic treatment
  SELECT TOP 1 @LastJ01Date=StartAt,@DrugName=DrugName FROM dbo.DrugTreatment
    WHERE ( ( ATC LIKE 'J01%' ) OR ( ATC LIKE 'P01A%' ) ) AND PersonId=@PersonId
      AND ((StartAt > getdate()-30) OR ( StopAt IS NULL ) OR ( StopAt > getdate()) ) ORDER BY StartAt DESC;
  IF @LastJ01Date IS NULL
    EXEC dbo.AddAlertForDSSRule @StudyId,@PersonId,0,'INFECTION','Exclude'
  ELSE BEGIN 
    SET @LastFormDate = dbo.GetLastSignedForm( @StudyId, @PersonId,'GBD_INFECTION' );
    IF ( @LastFormDate IS NULL ) OR ( @LastJ01Date > @LastFormDate + 1 ) BEGIN
      SET @MsgText = dbo.GetTextItem( 'INFECTION','DataMissing' );
      IF @LastFormDate IS NULL
        SET @FormDateText = '(aldri)'
      ELSE
        SET @FormDateText = dbo.LongTime( @LastFormDate );
      SET @MsgText = REPLACE( @MsgText, '@DrugDate', '<b>' + dbo.LongTime( @LastJ01Date ) + '</b>' );
      SET @MsgText = REPLACE( @MsgText, '@FormDate', '<b>' + @FormDateText +'</b>' );
      SET @MsgText = REPLACE( @MsgText, '@DrugName', '<b>' + @DrugName +'</b>' );
      EXEC dbo.AddAlertForPerson @StudyId,@PersonId,2,'INFECTION','DataMissing','Infeksjonsregistrering',@MsgText;
    END
    ELSE
      EXEC dbo.AddAlertForDSSRule @StudyId,@PersonId,0,'INFECTION','DataFound'
  END;
END;
GO

GRANT EXECUTE ON [GBD].[RuleInfectionForm] TO [FastTrak]
GO