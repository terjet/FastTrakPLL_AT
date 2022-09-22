SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CalculateMedian]( @ValueTable dbo.QuantityTableType READONLY ) RETURNS DECIMAL(18, 4)
AS
BEGIN
  DECLARE @RetVal DECIMAL(18, 4);
  DECLARE @c BIGINT = (SELECT COUNT(*) FROM @ValueTable);
 
  SELECT @RetVal = AVG(1.0 * Quantity)
  FROM (
      SELECT Quantity FROM @ValueTable
       ORDER BY Quantity
       OFFSET (@c - 1) / 2 ROWS
       FETCH NEXT 1 + (1 - @c % 2) ROWS ONLY
  ) AS x;

  RETURN @RetVal;
END
GO