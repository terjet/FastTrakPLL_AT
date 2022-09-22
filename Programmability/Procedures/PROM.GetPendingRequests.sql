SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[GetPendingRequests]( @PersonId INT ) AS
BEGIN
  SELECT RowId, FormId, FormOrderId, ExpiryDate, OrderStatus, CreatedAt 
  FROM PROM.FormOrder WHERE NOT OrderStatus IN ( 'Completed', 'Expired' ) 
  AND PersonId = @PersonId;
END
GO

GRANT EXECUTE ON [PROM].[GetPendingRequests] TO [FastTrak]
GO