SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateClinProblemType]( @ProbId INT, @ProbType CHAR(1)) AS
  DECLARE @PersonId INT;
BEGIN
  UPDATE dbo.ClinProblem SET ProbType=@ProbType,UpdatedAt=GetDate(),UpdatedBy=USER_ID()
    WHERE ProbId=@ProbId AND ProbType<>@ProbType;
  IF @@ROWCOUNT = 1 BEGIN
    SELECT @PersonId=PersonId FROM ClinProblem WHERE ProbId=@ProbId; 
    UPDATE StudCase SET LastWrite=getdate() WHERE PersonId=@PersonId;          
  END;
END;
GO