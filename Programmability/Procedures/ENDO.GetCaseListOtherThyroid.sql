SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetCaseListOtherThyroid] ( @StudyId INT )
AS
BEGIN
  SELECT p.PersonId, p.DOB, p.ReverseName as FullName,sg.GroupName,
    dbo.GetLastEnumVal(p.PersonId,'VAR8002') as Var8002,
    dbo.GetLastEnumVal(p.PersonId,'VAR6642') as Var6642
  INTO #tempAll 
  FROM dbo.Person p
  JOIN dbo.StudCase sc ON sc.PersonId=p.PersonId
  JOIN dbo.Study s ON s.StudyId=sc.StudyId AND s.StudyId=@StudyId
  LEFT OUTER JOIN dbo.StudyGroup Sg ON sg.StudyId=sc.StudyId and sg.GroupId=sc.GroupId;
  select t.PersonId,t.DOB,t.FullName,t.GroupName, RTRIM(LTRIM(ISNULL(mia6642.OptionText,'') + ' '+ ISNULL(mia8002.OptionText,''))) as InfoText
  FROM #tempAll t 
  LEFT OUTER JOIN dbo.MetaItemAnswer mia6642 ON mia6642.OrderNumber=t.Var6642 AND mia6642.ItemId=6642
  LEFT OUTER JOIN dbo.MetaItemAnswer mia8002 ON mia8002.OrderNumber=t.Var8002 AND mia8002.ItemId=8002
  WHERE ISNULL(Var6642,0)=4 or ISNULL(Var8002,0)=9 
  ORDER BY FullName
END
GO

GRANT EXECUTE ON [ENDO].[GetCaseListOtherThyroid] TO [FastTrak]
GO