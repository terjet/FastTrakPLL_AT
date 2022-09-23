SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [VREX].[GetCaseListRandomization]( @StudyId INT ) AS
BEGIN
  SELECT v.*, 'RAN#' + FORMAT(q.Quantity,'00#') AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  LEFT JOIN dbo.GetLastQuantityTable( 10185, NULL ) q ON q.PersonId = v.PersonId
  WHERE @StudyId = @StudyId;
END
GO

GRANT EXECUTE ON [VREX].[GetCaseListRandomization] TO [FastTrak]
GO