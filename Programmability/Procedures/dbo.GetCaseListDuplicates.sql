SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDuplicates]( @StudyId INT ) AS
BEGIN
  SELECT p1.PersonId, p1.DOB, p1.ReverseName AS FullName, 'Obs' AS GroupName,
  CONVERT( VARCHAR, p2.PersonId ) + ' ' + p2.ReverseName AS InfoText 
  FROM dbo.Person p1 
  JOIN dbo.Person p2 ON p2.DOB = p1.DOB 
  WHERE ( p1.PersonId <> p2.PersonId AND p1.GenderId = p2.GenderId )
  AND ( LTRIM( RTRIM( p1.LstName ) ) = LTRIM( RTRIM( p2.LstName ) ) )
  ORDER BY p1.DOB;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListDuplicates] TO [FastTrak]
GO