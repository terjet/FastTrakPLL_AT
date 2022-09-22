SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetProblemsStudy]( @StudyId INT )
AS
BEGIN
  SELECT cp.PersonId,cp.ProbDebut as ProbTime,i.ItemCode,i.ItemName,l.ListId
  FROM ClinProblem cp
  JOIN StudCase sc on sc.PersonId=cp.PersonId AND sc.StudyId=@StudyId
  JOIN MetaNomListItem li on cp.ListItem=li.ListItem
  JOIN MetaNomItem i on i.ItemId=li.ItemId  
  JOIN MetaNomList l on l.ListId=li.ListId
END
GO

GRANT EXECUTE ON [dbo].[GetProblemsStudy] TO [FastTrak]
GO