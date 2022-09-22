SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddDrugTemplateByExample] @TreatId INTEGER, @FriendlyName varchar(64) = NULL
  AS
  DECLARE @StrippedDrugname varchar(64);
  DECLARE @QuotePos INT;
  BEGIN
    /* Remove names of distributors from templates */
  SELECT @StrippedDrugname = DrugName FROM DrugTreatment WHERE TreatId=@TreatId;
  SELECT @QuotePos=CHARINDEX('"',@StrippedDrugName );
  IF ( NOT @QuotePos IS NULL) AND ( @QuotePos>1 )
    SELECT @StrippedDrugname=RTRIM(SUBSTRING(@StrippedDrugname,1,@QuotePos-1))
  /* Create template name if needed */
  IF @FriendlyName IS NULL BEGIN
    SELECT @FriendlyName = @StrippedDrugName + ' ' + DrugForm + ' ' +
      LTRIM(STR(Strength)) + StrengthUnit + ' (' + StartReason +')'
      FROM DrugTreatment WHERE TreatId=@TreatId;
  END;
  /* Check for existense of this name */
  IF EXISTS( SELECT FriendlyName FROM DrugTemplate WHERE FriendlyName=@FriendlyName ) RETURN -4;
  /* Finally insert template */
  INSERT INTO DrugTemplate (FriendlyName,ATC,DrugName,DrugForm,Strength,StrengthUnit,DoseCode,StartReason)
    SELECT @FriendlyName,ATC,@StrippedDrugName,DrugForm,Strength,StrengthUnit,DoseCode,StartReason
    FROM DrugTreatment WHERE TreatId=@TreatId;
  IF @@ERROR <> 0 RETURN -ABS(@@ERROR);
END;
GO

GRANT EXECUTE ON [dbo].[AddDrugTemplateByExample] TO [FastTrak]
GO