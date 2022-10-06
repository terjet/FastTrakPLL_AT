SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [NDV].[GetCvdTable]( @CutoffDate DATETIME ) 
RETURNS @CvdTable TABLE ( PersonId INT NOT NULL PRIMARY KEY, Treated INT, CHD INT, Stroke INT, Amputation INT, ArterialSurgery INT, HasCVD BIT DEFAULT 0 ) AS
BEGIN
  INSERT @CvdTable
  SELECT PersonId, [3337], [3397], [3398], [3414], [3417], 0
  FROM  
  (
    SELECT PersonId, ItemId, EnumVal 
    FROM 
    (
      SELECT ce.PersonId, cdp.ItemId, cdp.EnumVal, ce.EventTime, 
        ROW_NUMBER() OVER ( PARTITION BY ce.PersonId, cdp.ItemId ORDER BY ce.EventNum DESC ) AS ReverseNumber
      FROM dbo.ClinDataPoint cdp
        JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId
      WHERE cdp.ItemId IN ( 3337, 3397, 3398, 3414, 3417 )
      AND ( ce.EventTime <= @CutoffDate ) AND ( ISNULL( cdp.EnumVal, -1 ) <> -1 )
    ) LastValues
    WHERE LastValues.ReverseNumber = 1
  )
  SourceTable
  PIVOT             
  ( MAX( EnumVal )
    FOR ItemId IN ( [3337], [3397], [3398], [3414], [3417] )
  ) PivotTable;
  UPDATE @CvdTable SET HasCVD = 1  
  WHERE NOT ( ( ISNULL( CHD, -1 ) <> 1 ) AND ( ISNULL( Stroke, -1 ) <> 1 ) AND ( ISNULL( Amputation, -1 ) NOT IN ( 2, 3 ) ) AND ( ISNULL( ArterialSurgery, -1 ) <> 1 ) );
  RETURN;
END
GO

GRANT SELECT ON [NDV].[GetCvdTable] TO [Administrator]
GO