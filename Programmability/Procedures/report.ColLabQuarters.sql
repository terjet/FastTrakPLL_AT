SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[ColLabQuarters]( @LabClassId INT ) AS 
BEGIN
  SELECT agg.PersonId, CONCAT(agg.NLK, '.', agg.y,'.Q',agg.q ) AS VarName, NumResult, LabDate, ResultId
  FROM 
  (
    SELECT ld.PersonId, cl.NLK, DATEPART( YEAR, ld.LabDate ) AS y, DATEPART( QUARTER, ld.LabDate ) AS q, ld.NumResult, ld.LabDate, ld.ResultId, 
      ROW_NUMBER () OVER ( PARTITION BY PersonId, DATEPART( YEAR, LabDate ), DATEPART( QUARTER, LabDate ) ORDER BY LabDate DESC ) AS ReverseOrder
    FROM dbo.LabData ld
    JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
    JOIN dbo.LabClass cl ON cl.LabClassId = lc.LabClassId
    WHERE lc.LabClassId = @LabClassId AND ld.LabDate > GETDATE() - 365
  ) agg 
  WHERE ReverseOrder = 1
  ORDER BY LabDate;
END
GO

GRANT EXECUTE ON [report].[ColLabQuarters] TO [FastTrak]
GO