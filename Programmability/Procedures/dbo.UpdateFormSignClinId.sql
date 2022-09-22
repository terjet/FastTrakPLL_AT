SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateFormSignClinId]( @ClinFormId INT ) AS
BEGIN
  -- Procedure has a non-conventional name. It is used in v5, can be removed for v6.
  DECLARE @MsgText VARCHAR(512);
  UPDATE dbo.ClinForm SET SignedAt=GETDATE(),SignedBy=USER_ID(),FormStatus='L'
    WHERE ClinFormId=@ClinFormId AND (SignedBy IS NULL );
  IF @@ROWCOUNT=0
  BEGIN
    SET @MsgText = dbo.GetTextItem( 'UpdateFormSignClinId','Failed' );
    RAISERROR (@MsgText,16,1 );
    RETURN -1;
  END
  ELSE
    EXEC CRF.UpdateClinFormSignItems @ClinFormId;              
END
GO

GRANT EXECUTE ON [dbo].[UpdateFormSignClinId] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateFormSignClinId] TO [ReadOnly]
GO