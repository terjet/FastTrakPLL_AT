SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ShortTreatments] AS 
SELECT TreatId,dt.DrugName,dt.CreatedAt,dt.StartAt,dt.StopAt,
  StartedBy,StopBy,p.FullName,pu.FullName as CreatorName,
  convert( float, dt.StopAt - dt.CreatedAt)*24*60*60 AS SecondsActive
FROM DrugTreatment dt
JOIN Person p on p.PersonId=dt.PersonId
JOIN UserList ul on ul.UserId=dt.CreatedBy
JOIN Person pu ON pu.PersonId=ul.PersonId
WHERE StopAt < StartAt
GO