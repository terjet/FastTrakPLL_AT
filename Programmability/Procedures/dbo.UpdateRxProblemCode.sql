SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateRxProblemCode]( @PrescId INT, @ProbCode VARCHAR(8) ) AS
BEGIN
  UPDATE DrugPrescription SET ProbCode=@ProbCode WHERE PrescId=@PrescId;
END
GO

GRANT EXECUTE ON [dbo].[UpdateRxProblemCode] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateRxProblemCode] TO [ReadOnly]
GO