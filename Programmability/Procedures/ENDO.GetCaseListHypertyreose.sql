SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetCaseListHypertyreose] ( @StudyId INT )
AS
BEGIN
  SELECT p.PersonId, p.DOB, p.ReverseName as FullName,sg.GroupName,dbo.GetLastEnumVal(p.PersonId,'VAR6658') as Var6658 
  INTO #tempAll 
  FROM dbo.Person p
  JOIN dbo.StudCase sc ON sc.PersonId=p.PersonId
  JOIN dbo.Study s ON s.StudyId=sc.StudyId AND s.StudyId=@StudyId
  LEFT OUTER JOIN dbo.StudyGroup Sg ON sg.StudyId=sc.StudyId and sg.GroupId=sc.GroupId;
  select t.PersonId,t.DOB,t.FullName,t.GroupName,mia.OptionText as InfoText
  FROM #tempAll t 
  JOIN dbo.MetaItemAnswer mia ON mia.OrderNumber=t.Var6658 AND mia.ItemId=6658
  ORDER BY FullName
END
GO

GRANT EXECUTE ON [ENDO].[GetCaseListHypertyreose] TO [FastTrak]
GO