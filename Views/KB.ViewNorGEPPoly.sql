SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [KB].[ViewNorGEPPoly]
AS
  SELECT PersonId,count(*) as DrugCount FROM KB.ViewDistinctDrugs 
  WHERE (CHARINDEX('N06A',ATC ) = 1 OR CHARINDEX('N05BA',ATC ) = 1 OR CHARINDEX('N05',ATC ) = 1 OR CHARINDEX('N02A',ATC ) = 1)
  GROUP BY PersonId
  HAVING count(*) > 2
GO

GRANT SELECT ON [KB].[ViewNorGEPPoly] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [KB].[ViewNorGEPPoly] TO [public]
GO