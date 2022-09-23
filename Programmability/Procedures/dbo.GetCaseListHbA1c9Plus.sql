SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListHbA1c9Plus]( @StudyId INT ) AS
BEGIN
  SELECT v.*, CONCAT( 'Type ', DiaType.ShortCode, ', HbA1c: ', HbA1c.NumResult ) AS InfoText
  FROM dbo.ViewActiveCaseListStub v 
  JOIN dbo.GetLastLabDataTable( 1058, GETDATE() ) AS HbA1c ON HbA1c.PersonId = v.PersonId
  JOIN dbo.GetLastEnumValuesTable( 3196, GETDATE() ) AS DiaType ON DiaType.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND ( HbA1c.NumResult >= 75)
  ORDER BY HbA1c.NumResult DESC;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListHbA1c9Plus] TO [FastTrak]
GO