SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteDrug]( @TreatId INT )
AS
  DECLARE @PersonId INT;
  DECLARE @MsgText varchar(512);
BEGIN
  /* Find person and at the same time determine deletability of drug */
  SELECT @PersonId = PersonId FROM DrugTreatment WHERE TreatId=@TreatId
    AND CreatedBy=USER_ID() AND CreatedAt>getdate()- 1;
  IF @PersonId IS NULL 
  BEGIN
    SET @MsgText = dbo.GetTextItem( 'DeleteDrug','Failed' )
    RAISERROR( @MsgText, 16, 1 );
    RETURN -1;
  END
  ELSE 
  BEGIN
    /* Delete drug dosing first, or we get a FK violation */
    DELETE FROM DrugDosing WHERE TreatId=@TreatId;
    DELETE FROM DrugPause WHERE TreatId=@TreatId;
    DELETE FROM DrugTreatment WHERE TreatId=@TreatId;
    UPDATE StudCase SET LastWrite = getdate() WHERE PersonId=@PersonId;
  END;
END;
GO

GRANT EXECUTE ON [dbo].[DeleteDrug] TO [FastTrak]
GO