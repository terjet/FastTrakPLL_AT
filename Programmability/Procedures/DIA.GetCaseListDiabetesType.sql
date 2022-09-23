SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [DIA].[GetCaseListDiabetesType]( @StudyId INT, @DiaType INT ) AS
BEGIN
  SELECT v.*, '' AS InfoText 
  FROM DIA.DiabetesType dia
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = DIA.PersonId
  WHERE v.StudyId = @StudyId AND dia.DiaType = @DiaType;
END
GO

GRANT EXECUTE ON [DIA].[GetCaseListDiabetesType] TO [FastTrak]
GO