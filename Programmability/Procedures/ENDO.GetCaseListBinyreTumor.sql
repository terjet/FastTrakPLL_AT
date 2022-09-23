SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetCaseListBinyreTumor] ( @StudyId INT )
AS
BEGIN
  SELECT p.PersonId, p.DOB, p.ReverseName as FullName,sg.GroupName,
    dbo.GetLastEnumVal(p.PersonId,'VAR5733') as Var5733
  INTO #tempAll 
  FROM dbo.Person p
  JOIN dbo.StudCase sc ON sc.PersonId=p.PersonId
  JOIN dbo.Study s ON s.StudyId=sc.StudyId AND s.StudyId=@StudyId
  LEFT OUTER JOIN dbo.StudyGroup Sg ON sg.StudyId=sc.StudyId and sg.GroupId=sc.GroupId;
  select t.PersonId,t.DOB,t.FullName,t.GroupName, 'Binyretumor' as InfoText
  FROM #tempAll t 
  JOIN dbo.MetaItemAnswer mia5733 ON mia5733.OrderNumber=Var5733 AND mia5733.ItemId=5733
  WHERE ISNULL(Var5733,0)=1 
  ORDER BY FullName
END
GO

GRANT EXECUTE ON [ENDO].[GetCaseListBinyreTumor] TO [FastTrak]
GO