SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[UpdateClinFormUnsign]( @ClinFormId INT ) AS
BEGIN
  DECLARE @CanUnsign INT;
  DECLARE @MessageText VARCHAR(MAX);    
  -- Make sure we can unsign this form
  EXEC dbo.CanUnsignForm @ClinFormId, @CanUnsign OUTPUT, @MessageText OUTPUT;
  IF @CanUnsign > 0                                                
  BEGIN                                          
    -- Unsign the form itself 
    UPDATE dbo.ClinForm SET SignedAt=NULL,SignedBy=NULL,FormStatus='I' WHERE ClinFormId=@ClinFormId;
    -- Unsign standard variables
    EXEC CRF.UpdateClinFormUnsignItems @ClinFormId
    RETURN 1;
  END
  ELSE
  BEGIN  
    RAISERROR( @MessageText, 16, 1 )
    RETURN -2;
  END;
END
GO

GRANT EXECUTE ON [CRF].[UpdateClinFormUnsign] TO [FastTrak]
GO

DENY EXECUTE ON [CRF].[UpdateClinFormUnsign] TO [ReadOnly]
GO