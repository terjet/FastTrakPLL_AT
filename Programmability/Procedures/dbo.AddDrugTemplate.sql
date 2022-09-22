SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddDrugTemplate]
  @FriendlyName varchar(64),
  @ATC varchar(7),
  @DrugName varchar(64),
  @DrugForm varchar(64),
  @Strength decimal(12,4),
  @StrengthUnit varchar(24),
  @DoseCode varchar(24),
  @StartReason varchar(64)
AS
DECLARE @CreatedBy INT;
BEGIN
  SELECT @CreatedBy = CreatedBy FROM DrugTemplate WHERE FriendlyName=@FriendlyName;
  IF @CreatedBy IS NULL BEGIN
    INSERT INTO DrugTemplate
     (FriendlyName,ATC,DrugName,DrugForm,Strength,StrengthUnit,DoseCode,StartReason )
    VALUES
      (@FriendlyName,@ATC,@DrugName,@DrugForm,@Strength,@StrengthUnit,@DoseCode,@StartReason );
    RETURN @@ROWCOUNT;
  END
  ELSE BEGIN
    /* IF @CreatedBy<>USER_NAME() RETURN -4; */
    UPDATE DrugTemplate SET ATC=@ATC,DrugName=@DrugName,DrugForm=@DrugForm,
      Strength=@Strength,StrengthUnit=@StrengthUnit,
      DoseCode=@DoseCode,StartReason=@StartReason,UpdatedBy=user_id(),
      UpdatedAt=getdate()
    WHERE FriendlyName=@FriendlyName;
    RETURN @@ROWCOUNT;
  END;
END;
GO