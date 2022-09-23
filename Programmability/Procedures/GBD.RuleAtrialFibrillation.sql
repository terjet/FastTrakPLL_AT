SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleAtrialFibrillation]( @StudyId INT, @PersonId INT ) AS
BEGIN
  DECLARE @HasAF INT;
  DECLARE @HeaderText VARCHAR(64);
  DECLARE @MsgText VARCHAR(512);
  DECLARE @AlertFacet VARCHAR(16);
  DECLARE @AlertLevel INT;
  SET @HasAF = dbo.GetProblemStatus( @PersonId,4, 'I48%' );
  IF @HasAF = 1
  BEGIN
    IF EXISTS( SELECT TreatId FROM dbo.OngoingTreatment 
      WHERE PersonId=@PersonId AND ATC COLLATE Latin1_General_CI_AS LIKE 'B01A[ABCEF]%' COLLATE Latin1_General_CI_AS )
    BEGIN
      SET @AlertLevel = 0;
      SET @AlertFacet = 'DrugFound';
    END  
    ELSE
    BEGIN
      SET @AlertLevel = 2;
      SET @AlertFacet = 'DrugGive';
    END
  END
  ELSE BEGIN
    SET @AlertLevel = 0;
    SET @AlertFacet = 'Exclude'
  END;
  SET @MsgText = dbo.GetTextItem( 'AFTREATED', @AlertFacet )  
  SET @HeaderText = dbo.GetTextItem( 'AFTREATED', @AlertFacet + '.Header' )  
  EXEC dbo.AddAlertForPerson @StudyId,@PersonId,@AlertLevel,'AFTREATED',@AlertFacet,@HeaderText,@MsgText
END
GO

GRANT EXECUTE ON [GBD].[RuleAtrialFibrillation] TO [FastTrak]
GO