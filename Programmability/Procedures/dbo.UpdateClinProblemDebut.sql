SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateClinProblemDebut]( @ProbId INT, @ProbDebut DateTime )
AS
BEGIN
  IF @ProbDebut < 0 SET @ProbDebut = NULL;
  UPDATE ClinProblem SET ProbDebut = @ProbDebut WHERE ProbId=@ProbId;
END
GO