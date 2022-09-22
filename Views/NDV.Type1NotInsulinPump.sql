SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [NDV].[Type1NotInsulinPump] AS 
  SELECT v.PersonId,v.DOB,v.FullName,sg.GroupName, (CONVERT(FLOAT,getdate()) - CONVERT(FLOAT,v.DOB) )/365.25 as Age
  FROM ViewActiveCaseListStub v
  JOIN dbo.StudCase sc ON sc.StudyId=v.StudyId AND sc.PersonId=v.PersonId
  JOIN dbo.StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId=sc.GroupId AND sg.GroupActive=1
  JOIN dbo.Study s ON s.StudyId=v.StudyId AND s.StudyName='NDV'
  WHERE  dbo.GetLastQuantity( v.PersonId, 'NDV_TYPE') = 1 AND NOT dbo.GetLastQuantity( v.PersonId, 'NDV_INSULIN_DEVICE') = 2
GO