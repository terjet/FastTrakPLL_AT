SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListProblem]( @StudyId INT, @ProbCode VARCHAR(8) ) AS
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,i.ItemCode + ' ' + i.ItemName AS InfoText
  FROM ViewActiveCaseListStub v
  LEFT OUTER JOIN dbo.ClinProblem cp ON cp.PersonId=v.PersonId AND v.StudyId=@StudyId
  JOIN dbo.MetaNomListItem li ON li.ListItem=cp.ListItem
  JOIN dbo.MetaNomItem i on i.ItemId=li.ItemId
  WHERE ( i.ItemCode LIKE @ProbCode )
  ORDER BY GroupName
END
GO