SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[GetPeopleWithPendingRequests] AS
BEGIN
  SELECT DISTINCT p.NationalId FROM dbo.Person p
  JOIN PROM.FormOrder fo ON fo.PersonId = p.PersonId
  WHERE fo.OrderStatus = 'Waiting'
END
GO