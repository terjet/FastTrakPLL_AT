SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[OpenImportContext]( @StudyName varchar(40), @ContextName varchar(64), @DeleteExisting BIT = 0 ) AS
BEGIN
  SET NOCOUNT ON;  
  DECLARE @StudyId INT = NULL;
  DECLARE @ContextId INT = NULL;
  DECLARE @BatchId INT = NULL;
  DECLARE @LastUpdate DateTime = NULL;                                                     
  SELECT @StudyId = StudyId FROM dbo.Study WHERE StudName = @StudyName;
  IF NOT @StudyId IS NULL 
  BEGIN                              
    SELECT @ContextId = ContextId 
	FROM dbo.ImportContext WHERE StudyId = @StudyId AND ContextName = @ContextName;
    IF @ContextId IS NULL 
	BEGIN            
      INSERT INTO dbo.ImportContext ( StudyId, ContextName ) VALUES( @StudyId, @ContextName );
      SET @ContextId = SCOPE_IDENTITY();
    END
    ELSE IF @DeleteExisting = 1
      DELETE FROM dbo.ImportBatch WHERE ContextId = @ContextId; 
    SELECT @LastUpdate = MAX( LastUpdate ) FROM dbo.ImportContext WHERE ContextName = @ContextName; 
    INSERT INTO dbo.ImportBatch ( ContextId ) VALUES ( @ContextId );
    SET @BatchId = SCOPE_IDENTITY();
  END;                            
  SELECT ContextId, LastUpdate, @BatchId AS BatchId FROM dbo.ImportContext WHERE ContextId = @ContextId; 
END
GO