SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetCaseListHbA1cBelow53]( @StudyId INT ) AS
BEGIN
  SELECT 
     v.*, FORMAT( glqt.Quantity, 'HbA1c = # mmol/mol' ) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastQuantityTable( 3018, NULL ) glqt ON glqt.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND glqt.Quantity < 53
  ORDER BY glqt.Quantity;
END
GO

GRANT EXECUTE ON [BDR].[GetCaseListHbA1cBelow53] TO [FastTrak]
GO