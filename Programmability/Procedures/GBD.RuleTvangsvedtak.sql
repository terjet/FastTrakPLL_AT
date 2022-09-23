SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleTvangsvedtak]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @EventTime DateTime;
  DECLARE @StopDate DateTime;
  DECLARE @StopDateText VARCHAR(24);
  DECLARE @StopAction INT;
  DECLARE @DaysPastDue INT;    
  DECLARE @ClinFormId INT;
  DECLARE @AlertClass VARCHAR(16);                                         
  DECLARE @AlertHeader VARCHAR(64);
  DECLARE @AlertMessage VARCHAR(512);    
  DECLARE @AlertLevel INT;
  DECLARE @HiddenAlertModifier VARCHAR(30);
  DECLARE cur_vedtak CURSOR FAST_FORWARD FOR   
    SELECT EventTime,StopDate, StopAction,DaysPastDue, ClinFormId FROM GBD.Tvangsvedtak
    WHERE StudyId=@StudyId AND PersonId=@PersonId;
  OPEN cur_vedtak;
  FETCH NEXT FROM cur_vedtak INTO @EventTime,@StopDate,@StopAction,@DaysPastDue,@ClinFormId;
  WHILE @@FETCH_STATUS = 0
  BEGIN            
    SET @AlertMessage = '<a href="about://SelectForm?ClinFormId='+CONVERT(VARCHAR,@ClinFormId)+'">Tvangsvedtak</a> ' + CONVERT(VARCHAR,@EventTime,4);
    SET @AlertClass = 'TVANG#' + CONVERT(VARCHAR,@ClinFormId);
    IF @StopAction <> 1  
    BEGIN                   
      SET @AlertLevel = 0;
      IF @DaysPastDue > 0
        SET @HiddenAlertModifier = 'er avsluttet.';
      ELSE
        SET @HiddenAlertModifier = 'er aktivt.';
      SELECT @AlertHeader = 
      CASE @StopAction 
        WHEN 2 THEN 'Automatisk avslutning'
        WHEN 3 THEN 'Aktivt avsluttet'
        WHEN 4 THEN 'Fornyet vedtak'
        ELSE 'Ukjent håndtering'
      END;
      SET @AlertMessage = @AlertMessage + ' ' + @HiddenAlertModifier + ' Det er ikke bedt om påminnelser i forbindelse med avslutning av dette vedtaket.'; -- meldingstekst endra
    END
    ELSE        
    BEGIN
      SET @StopDateText = ISNULL(CONVERT(VARCHAR,@StopDate,104),'(uspesifisert dato)');
      IF @DaysPastDue > 0 
      BEGIN
        SET @AlertLevel = 3;
        SET @AlertHeader = 'Utgått tvangsvedtak'
        SET @AlertMessage = @AlertMessage + ' utløp ' + @StopDateText + '.  ' + 
          'Dette vedtaket er ikke eksplisitt avsluttet.  Du bør gjenåpne skjemaet og avslutte vedtaket.'; 
      END
      ELSE IF @DaysPastDue >= -21 -- nytt vilkår
      BEGIN                       
        SET @AlertLevel = 2;
        SET @AlertHeader = 'Forny tvangsvedtak';
        SET @AlertMessage = @AlertMessage + ' utløper ' + @StopDateText + '!  Du bør aktivt avslutte dette eller fornye det.';
      END
      ELSE -- ny skjult påminning
      BEGIN
        SET @AlertLevel = 0;
        SET @AlertHeader = 'Aktivt tvangsvedtak';
        SET @AlertMessage = @AlertMessage + ' utløper ' + @StopDateText + '. Du vil få en påminnelse tre uker før utløpsdato.';
      END
    END;    
    EXEC dbo.AddAlertForPerson @StudyId,@PersonId,@ALertLevel,@AlertClass,'Include',@AlertHeader,@AlertMessage,'TWF';
    FETCH NEXT FROM cur_vedtak INTO @EventTime,@StopDate,@StopAction,@DaysPastDue,@ClinFormId;
  END;
  CLOSE cur_vedtak;
  DEALLOCATE cur_vedtak;
END
GO

GRANT EXECUTE ON [GBD].[RuleTvangsvedtak] TO [FastTrak]
GO