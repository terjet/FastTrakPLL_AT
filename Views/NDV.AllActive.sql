SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [NDV].[AllActive] (PersonId, DOB, FullName, GroupName, Age) 
AS
SELECT v.PersonId,v.DOB,v.FullName,sg.GroupName, (CONVERT(FLOAT,getdate()) - CONVERT(FLOAT,v.DOB) )/365.25 as Age
  FROM ViewActiveCaseListStub v
  JOIN dbo.StudCase sc ON sc.StudyId=v.StudyId AND sc.PersonId=v.PersonId
  JOIN dbo.StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId=sc.GroupId AND sg.GroupActive=1 
  JOIN dbo.Study s ON s.StudyId=v.StudyId AND s.StudyName='NDV'
GO

GRANT SELECT ON [NDV].[AllActive] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [NDV].[AllActive] TO [public]
GO