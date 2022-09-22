SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Comm].[SendMessage]( @ClinFormId INT, @PartnerId INT, @MessageText VARCHAR(MAX), @MsgGuid uniqueidentifier = NULL ) AS
BEGIN
  DECLARE @FormStatus CHAR(1);    
  DECLARE @SrvReportStatus CHAR(1);
  DECLARE @PersonId INT;
  DECLARE @OutId INT;
  IF @MsgGuid IS NULL SET @MsgGuid = NEWID();
  SELECT @PersonId = ce.PersonId, @FormStatus=cf.FormStatus 
    FROM dbo.ClinForm cf JOIN dbo.ClinEvent ce ON ce.EventId=cf.EventId 
    WHERE ClinFormId=@ClinFormId;        
  -- Set Final for signed form, otherwise use Preliminary
  IF @FormStatus='L' SET @SrvReportStatus='F' ELSE SET @SrvReportStatus='P';
  SELECT @OutId = OutId FROM COMM.OutBox 
    WHERE ( ClinFormId=@ClinFormId ) AND ( PartnerId=@PartnerId ) AND NOT ( PulledAt IS NULL ) AND ( SrvReportStatus='F' );
  IF NOT @OutId IS NULL
    RAISERROR( 'Meldingen er allerede sendt som endelig rapport til mottaker.\nDen kan dessverre ikke sendes på nytt til samme mottaker nå!', 16, 1 )
  ELSE
  BEGIN
    -- Looked for unpulled message with same status
    SELECT @OutId = OutId FROM COMM.OutBox 
      WHERE ClinFormId=@ClinFormId AND PartnerId=@PartnerId AND ( PulledAt IS NULL ) AND ( SrvReportStatus=@SrvReportStatus );
    IF NOT @OutId IS NULL
    BEGIN
      UPDATE COMM.OutBox SET MessageText=@MessageText,MsgGuid=@MsgGuid WHERE OutId=@OutId
      RAISERROR( 'Meldingen lå allerede i kø i utboksen, men er nå oppdatert med nye data!', 16, 1 )
    END      
    ELSE  
      INSERT INTO COMM.OutBox( ClinFormId, PersonId, PartnerId, MessageText, SrvReportStatus, MsgGuid )
        VALUES ( @ClinFormId, @PersonId, @PartnerId, @MessageText, @SrvReportStatus, @MsgGuid );
  END;
END
GO