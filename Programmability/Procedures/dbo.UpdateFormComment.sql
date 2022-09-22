SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateFormComment]( @EventId INT, @FormId INT, @MemoHeight INT, @Comment VARCHAR(MAX) )
AS
BEGIN
  DECLARE @ClinFormId INT;
  DECLARE @FormStatus CHAR(1);
  SELECT @ClinFormId=ClinFormId, @FormStatus=FormStatus 
  FROM dbo.ClinForm WHERE EventId=@EventId AND FormId=@FormId;
  IF @ClinFormId IS NULL 
  BEGIN
    INSERT INTO dbo.ClinForm (EventId,FormId) VALUES(@EventId,@FormId)
    SET @ClinFormId = SCOPE_IDENTITY();
  END;
  IF @FormStatus = 'L'
    RAISERROR( 'Skjemaet er signert, og kan ikke oppdateres', 16, 1 )
  ELSE 
    UPDATE dbo.ClinForm SET Comment=@Comment WHERE ( ClinFormId = @ClinFormId ) AND ( ISNULL(Comment,'') <> ISNULL(@Comment,'') );
END
GO