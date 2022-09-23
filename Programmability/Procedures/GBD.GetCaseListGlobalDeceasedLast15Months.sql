SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListGlobalDeceasedLast15Months]( @StudyId INT ) AS
BEGIN
  SELECT p.PersonId, p.DOB,
    p.ReverseName AS FullName, 
    p.GenderId, ss.StatusText AS GroupName, CONCAT('Død: ', FORMAT(DeceasedDate, 'dd.MM.yyyy')) AS InfoText
  FROM dbo.Person p 
  JOIN dbo.StudCase sc ON sc.PersonId = p.PersonId AND sc.StudyId = @StudyId
  JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId and ss.StatusId = sc.StatusId
  WHERE p.DeceasedDate >= GETDATE() - 450
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListGlobalDeceasedLast15Months] TO [QuickStat]
GO