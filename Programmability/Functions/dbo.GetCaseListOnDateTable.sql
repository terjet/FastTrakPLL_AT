SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCaseListOnDateTable]( @StudyId INT, @CutoffDate DATETIME )
RETURNS @CaseList TABLE (
    PersonId INT NOT NULL PRIMARY KEY,
    GroupId INT NOT NULL,
    CenterId INT NOT NULL,
    StatusId FLOAT NOT NULL,
    StatusText VARCHAR(64)
)
AS
BEGIN
  INSERT INTO @CaseList
  SELECT sc.PersonId, sg.GroupId, sg.CenterId, ss.StatusId, ss.StatusText
  FROM (SELECT StudCaseId, NewGroupId, NewStatusId, ChangedAt,
    ROW_NUMBER() OVER (PARTITION BY StudCaseId ORDER BY ChangedAt DESC) AS ReverseOrder
  FROM dbo.StudCaseLog
  WHERE ChangedAt < @CutoffDate) a
  JOIN dbo.StudCase sc ON sc.StudCaseId = a.StudCaseId
  JOIN dbo.StudyGroup sg ON sg.StudyId = sc.StudyId AND sg.GroupId = a.NewGroupId
  JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = a.NewStatusId
  WHERE a.ReverseOrder = 1 AND sc.StudyId = @StudyId;
  RETURN;
END;
GO