SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddClinProblem]( @PersonId INT, @ProbCode VARCHAR(8), @ListId INT, 
 @ProbDate DateTime = NULL, @ProbType char(1) = 'A', @BatchId INT = NULL ) AS
BEGIN
 DECLARE @ListItem INT;
 DECLARE @ProbId INT;  
 DECLARE @ProbInstId INT;
 DECLARE @LastDebut DateTime;                                                                             
 SET @ProbDate = ISNULL( @ProbDate, getdate() )
 SELECT @ListItem = ml.ListItem
   FROM dbo.MetaNomItem mni
   JOIN dbo.MetaNomListItem ml ON ml.ItemId=mni.ItemId AND ml.ListId=@ListId
 WHERE mni.ItemCode=@ProbCode;    
 IF @ListItem IS NULL
 BEGIN 
   RAISERROR( 'Unknown ProblemCode=%s, ListId=%d', 16, 1, @ProbCode, @ListId );
   RETURN -1;
 END
 ELSE BEGIN
   SELECT @ProbId=ProbId,@LastDebut=ProbDebut FROM ClinProblem WHERE PersonId=@PersonId AND ListItem=@ListItem;
   IF @ProbId IS NULL BEGIN
     UPDATE MetaNomListItem SET Popularity=Popularity+1 WHERE ListItem=@ListItem;
     INSERT INTO dbo.ClinProblem (PersonId,ListItem,ProbType,BatchId)
        VALUES ( @PersonId,@ListItem,@ProbType,@BatchId);
     UPDATE StudCase SET LastWrite = getdate() WHERE PersonId=@PersonId;
     SET @ProbId = SCOPE_IDENTITY()
   END;
   IF ( @LastDebut IS NULL ) OR ( @ProbDate < @LastDebut) 
     UPDATE ClinProblem SET ProbDebut=@ProbDate WHERE ProbId=@ProbId;
   UPDATE ClinProblem SET ProbType=@ProbType WHERE ProbId=@ProbId AND ProbDebut >= @ProbDate;
   SELECT @ProbInstId = ProbInstId FROM ClinProblemInstance WHERE ProbId=@ProbId AND ProbDate = @ProbDate;
   IF @ProbInstId IS NULL 
     INSERT INTO ClinProblemInstance( ProbId,ProbDate, ProbType ) VALUES(@ProbId,@ProbDate, @ProbType)
   ELSE 
     UPDATE ClinProblemInstance SET ProbType=@ProbType WHERE ProbInstId=@ProbInstId;
   SELECT @ProbId AS ProbId;
   RETURN @ProbId;
 END;
END
GO

GRANT EXECUTE ON [dbo].[AddClinProblem] TO [DataImport]
GO

GRANT EXECUTE ON [dbo].[AddClinProblem] TO [FastTrak]
GO