SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateClinProblemPriority]( @ProbId INT, @Priority INT )
AS
BEGIN
  UPDATE ClinProblem SET Priority=@Priority WHERE ProbId=@ProbId
END
GO

GRANT EXECUTE ON [dbo].[UpdateClinProblemPriority] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateClinProblemPriority] TO [ReadOnly]
GO