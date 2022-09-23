SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[GetPromOrders]( @StudyId INT, @StartDate DateTime, @StopDate DateTime ) AS
BEGIN
  SELECT DISTINCT v.*, fo.CreatedAt, 'Bestilt ' + dbo.ShortTime( fo.CreatedAt ) + ': ' + fo.OrderStatus AS InfoText 
  FROM PROM.FormOrder fo
  JOIN dbo.ViewCenterCaseListStub v ON v.PersonId = fo.PersonId
  WHERE v.StudyId = @StudyId AND fo.CreatedAt BETWEEN @StartDate AND @StopDate 
  ORDER BY fo.CreatedAt DESC;
END;
GO

GRANT EXECUTE ON [PROM].[GetPromOrders] TO [Avdelingsleder]
GO