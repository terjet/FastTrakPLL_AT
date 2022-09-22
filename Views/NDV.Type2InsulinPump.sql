SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [NDV].[Type2InsulinPump] AS
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName, (CONVERT(FLOAT,getdate()) - CONVERT(FLOAT,v.DOB) )/365.25 as Age
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.Person p ON p.PersonId=v.PersonId AND p.TestCase = 0
  JOIN dbo.Study s ON s.StudyId=v.StudyId AND s.StudyName IN ('NDV')
  JOIN dbo.GetLastEnumValuesTable( 3196, '2100-01-01' ) t3196 ON t3196.PersonId = v.PersonId
  JOIN dbo.GetLastEnumValuesTable( 4056, '2100-01-01' ) t4056 ON t4056.PersonId = v.PersonId
  WHERE t3196.EnumVal = 2 AND t4056.EnumVal = 2
GO