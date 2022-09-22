SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [report].[CaseCountByCenterAndGroup] 
AS
  SELECT sc.StudyId,sg.CenterId,c.CenterName,sg.GroupName,count(*) as GroupCount 
  FROM dbo.StudCase sc
  JOIN dbo.StudyGroup sg on sg.StudyId=sc.StudyId and sg.GroupId=sc.GroupId AND sg.GroupActive=1
  JOIN dbo.StudyStatus ss on ss.StudyId=sc.StudyId AND sc.FinState=ss.StatusId AND ss.StatusActive=1
  JOIN dbo.StudyCenter c ON c.CenterId=sg.CenterId
  GROUP BY sc.StudyId,sg.CenterId,c.CenterName,sg.GroupName
GO