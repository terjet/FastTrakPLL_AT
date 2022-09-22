SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateClinProblemSummary]( @ProbId INT, @ProbSummary TEXT, @ProbType CHAR(1) ) AS
  DECLARE @PersonId INT;
BEGIN
  UPDATE dbo.ClinProblem
    SET ProbSummary=@ProbSummary,ProbType=@ProbType,UpdatedAt=GetDate(),UpdatedBy=USER_ID()
    WHERE ProbId=@ProbId;
  IF @@ROWCOUNT = 1 BEGIN
    SELECT @PersonId=PersonId FROM ClinProblem WHERE ProbId=@ProbId; 
    UPDATE StudCase SET LastWrite=getdate() WHERE PersonId=@PersonId;          
  END;
END;
GO