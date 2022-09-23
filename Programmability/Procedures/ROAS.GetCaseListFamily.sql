SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetCaseListFamily]( @StudyId INT ) AS
BEGIN
  SELECT p.PersonId,p.DOB, p.ReverseName AS FullName, CONCAT( 'Familie #',CONVERT(INT,q1484.Quantity),'.') AS GroupName, p.GenderId,
  q1485.TextVal AS InfoText
  FROM dbo.Person p
  JOIN dbo.GetLastQuantityTable( 1484, NULL ) q1484 ON q1484.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastTextValuesTable( 1485,NULL) q1485 ON q1485.PersonId = p.PersonId
  ORDER BY q1484.Quantity, p.DOB;
END;
GO

GRANT EXECUTE ON [ROAS].[GetCaseListFamily] TO [FastTrak]
GO