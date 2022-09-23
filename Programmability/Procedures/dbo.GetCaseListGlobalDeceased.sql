SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListGlobalDeceased]( @StudyId INT ) AS
BEGIN
  SELECT p.PersonId, p.DOB,
    p.ReverseName AS FullName,
    -- CASE p.GenderId WHEN 1 THEN 'Mann, Avidentifisert' WHEN 2 THEN 'Kvinne, Avidentifisert' END AS FullName,  
    p.GenderId, ss.StatusText AS GroupName, DeceasedDate AS InfoText
  FROM dbo.Person p 
  JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId AND sc.StudyId = @StudyId
  JOIN dbo.StudyStatus ss ON ss.StudyId=sc.StudyId and ss.StatusId = sc.StatusId
  WHERE NOT p.DeceasedDate IS NULL;
END;
GO

GRANT EXECUTE ON [dbo].[GetCaseListGlobalDeceased] TO [QuickStat]
GO