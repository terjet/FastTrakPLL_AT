SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetCaseListUACRAbove3]( @StudyId INT ) AS
BEGIN
  SELECT v.*, FORMAT( glldt.NumResult, 'U-ACR = 0.# mg/mmol' ) AS InfoText
  FROM dbo.ViewActiveCaseListStub v 
  JOIN dbo.GetLastLabDataTable( 6, GETDATE() ) glldt ON v.PersonId = glldt.PersonId
  WHERE v.StudyId = @StudyId AND glldt.NumResult > 3 
  ORDER BY glldt.NumResult DESC;
END
GO

GRANT EXECUTE ON [BDR].[GetCaseListUACRAbove3] TO [FastTrak]
GO