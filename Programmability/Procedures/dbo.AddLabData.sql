SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddLabData]( @PersonId INT, @LabDate DateTime,@LabName varchar(40), @NumResult FLOAT,
  @DevResult INT = NULL, @TxtResult VARCHAR(MAX) = null, @Comment VARCHAR(MAX) = null,
  @ArithmeticComp Char(2) = NULL, @UnitStr varchar(24) = NULL, @BatchId INTEGER = NULL, @RefInterval VARCHAR(MAX) = NULL ) AS
BEGIN
  DECLARE @OrigCodeId INT;
  DECLARE @LabCodeId INT;
  DECLARE @TimeDiff FLOAT;
  DECLARE @LabDataId INT;
  SET NOCOUNT ON;
  SET @TimeDiff=1/24;
  IF @RefInterval = '' SET @RefInterval = NULL;
  SET @UnitStr = ISNULL(@UnitStr,'');
  /* Map the Code, should be fast, because LabName/UnitStr is indexed */
  SELECT @OrigCodeId = LabCodeId FROM dbo.LabCode WHERE LabName = @LabName AND UnitStr = @UnitStr;
  SELECT @LabCodeId = ISNULL(SynonymId,LabCodeId) FROM dbo.LabCode WHERE LabCodeId=@OrigCodeId;
  /* Create a new code for this name, if needed */
  IF @OrigCodeId IS NULL
  BEGIN
    INSERT INTO dbo.LabCode (LabName,UnitStr) VALUES(@LabName,@UnitStr);
    SET @OrigCodeId = SCOPE_IDENTITY();
    SET @LabCodeId = @OrigCodeId;
  END;           
  IF RTRIM(SUBSTRING(@TxtResult,1,255)) ='' SET @TxtResult = NULL; 
  /* Replace only same labdata (code,value,time) created by the same user, or batch-imported */
  UPDATE dbo.LabData SET LabCodeId=@LabCodeId,NumResult=@NumResult,
      DevResult=@DevResult,TxtResult=@TxtResult,Comment=@Comment,RefInterval=@RefInterval,
      ArithmeticComp=@ArithmeticComp,UnitStr=@UnitStr,BatchId=@BatchId
    WHERE PersonId=@PersonId AND ( OrigCodeId=@OrigCodeId OR LabCodeId=@LabCodeId )
    AND ( @LabDate=LabDate ) 
    AND ( (NOT @BatchId IS NULL) OR ( CreatedBy=USER_ID() OR NOT BatchId IS NULL ) );
  /* If no replacement was made, try to add the data */
  IF @@ROWCOUNT > 0
     SELECT @@ROWCOUNT AS RetCode,'Replacements done' AS RetText,@TimeDiff AS TimeDiff
  ELSE BEGIN
    INSERT INTO dbo.LabData (PersonId,LabDate,LabCodeId,OrigCodeId,NumResult,
        DevResult,TxtResult,Comment,RefInterval,
        ArithmeticComp,UnitStr,BatchId)
      VALUES( @PersonId,@LabDate,@LabCodeId,@OrigCodeId,@NumResult,
        @DevResult,@TxtResult,@Comment,@RefInterval,
        @ArithmeticComp,@UnitStr,@BatchId );
    SELECT 0 AS RetCode,'Data added' AS RetText,@TimeDiff AS TimeDiff
  END
  UPDATE dbo.StudCase SET LastWrite=GetDate() WHERE PersonId=@PersonId;
END
GO

GRANT EXECUTE ON [dbo].[AddLabData] TO [DataImport]
GO

GRANT EXECUTE ON [dbo].[AddLabData] TO [FastTrak]
GO