SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[CanUnsignClinForm]( @ClinFormId INT )
AS
  BEGIN
    -- Wraps dbo.CanUnsignForm by returning a dataset
    DECLARE @CanUnsign INT;
    DECLARE @ErrMsg VARCHAR(512);
    SET @CanUnsign = 1;
    EXEC dbo.CanUnsignForm @ClinFormId, @CanUnsign OUTPUT, @ErrMsg OUTPUT;
    SELECT @CanUnsign AS CanUnsign,@ErrMsg AS ErrMsg;
  END
GO

GRANT EXECUTE ON [CRF].[CanUnsignClinForm] TO [FastTrak]
GO