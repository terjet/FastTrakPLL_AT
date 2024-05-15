SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [Diagnose].[AddisonInferred]
AS
SELECT DISTINCT p.PersonId, CONVERT(INT, T6089.Quantity) AS ProbDebut, 
  CASE T6090.EnumVal
    WHEN 1 THEN 'E271'
    WHEN 2 THEN 'E250'
    WHEN 3 THEN 'E896'
    WHEN 4 THEN 'E187'
    WHEN 6 THEN 'E274'
    ELSE 'E279'
  END AS ItemCode, 
  T6090.OptionText AS ItemText, 1 AS OrderNo, 1 AS ReverseOrderNo, T6090.EnumVal AS T6090, T6299.EnumVal AS T6299
FROM dbo.Person p
LEFT JOIN dbo.GetLastEnumValuesTable(6090, NULL) AS T6090 ON T6090.PersonId = p.PersonId
LEFT JOIN dbo.GetLastEnumValuesTable(6299, NULL) AS T6299 ON T6299.PersonId = p.PersonId
LEFT JOIN dbo.GetLastQuantities(6089) AS T6089 ON T6089.PersonId = p.PersonId
WHERE ( T6090.EnumVal > 0 OR T6299.EnumVal = 1 OR T6089.Quantity > 1900 )
 AND ( NOT ISNULL( T6299.EnumVal, 0 ) IN ( 2, 3 ) )
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [Diagnose].[AddisonInferred] TO [public]
GO