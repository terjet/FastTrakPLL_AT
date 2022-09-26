SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetActiveCasesWithoutId] ( @StudyId INT ) AS
BEGIN
  SELECT v.*, 'Personnr: ' + ISNULL( p.NationalId, '(tomt)' ) AS InfoText 
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.Person p ON p.PersonId = v.PersonId 
  WHERE DATALENGTH( ISNULL( p.NationalId, '' ) ) <> 11;
END
GO

GRANT EXECUTE ON [dbo].[GetActiveCasesWithoutId] TO [FastTrak]
GO

GRANT EXECUTE ON [dbo].[GetActiveCasesWithoutId] TO [superuser]
GO