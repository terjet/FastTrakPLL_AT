SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetCaseListLDLAbove25]( @StudyId INT ) AS
BEGIN
  SELECT v.*, FORMAT( glldt.NumResult, 'LDL = 0.# mmol/L' ) AS InfoText
  FROM dbo.ViewActiveCaseListStub v 
  JOIN dbo.GetLastLabDataTable( 35, GETDATE() ) glldt ON v.PersonId = glldt.PersonId
  WHERE v.StudyId = @StudyId AND glldt.NumResult > 2.5 
  ORDER BY glldt.NumResult DESC;
END
GO

GRANT EXECUTE ON [BDR].[GetCaseListLDLAbove25] TO [FastTrak]
GO