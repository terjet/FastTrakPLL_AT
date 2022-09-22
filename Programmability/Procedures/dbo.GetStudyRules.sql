SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetStudyRules]( @StudyId INT ) AS
BEGIN
SELECT r.RuleId,r.Title,r.Description,r.RuleClass 
  FROM dbo.DSSRule r
  JOIN dbo.DSSStudyRule sr ON sr.RuleId=r.RuleId
  JOIN dbo.Study s ON s.StudyName=sr.StudyName
  WHERE s.StudyId=@StudyId;  
END
GO