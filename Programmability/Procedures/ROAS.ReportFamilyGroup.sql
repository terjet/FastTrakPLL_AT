SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[ReportFamilyGroup]( @PersonId INT ) AS 
BEGIN
  SELECT p.*, q1485.TextVal 
  FROM dbo.Person p
  JOIN dbo.GetLastQuantityTable( 1484, NULL ) q1484 ON q1484.PersonId = p.PersonId
  LEFT JOIN dbo.GetLastTextValuesTable( 1485, NULL ) q1485 ON q1485.PersonId = p.PersonId
  WHERE q1484.Quantity = dbo.GetLastQuantityInThePast( @PersonId, 1484, GETDATE() );
END
GO

GRANT EXECUTE ON [ROAS].[ReportFamilyGroup] TO [FastTrak]
GO