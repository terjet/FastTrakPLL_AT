SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [DIA].[GetLastStudyVisit]( @StudyId INT ) 
RETURNS @VisitTable TABLE ( PersonId INT NOT NULL PRIMARY KEY, UserId INT, UserGroup VARCHAR(32) NOT NULL, EventDate DATE ) AS
BEGIN
  INSERT INTO @VisitTable
  SELECT PersonId, UserId, ReverseName, CONVERT(DATE,EventTime) AS EventDate
  FROM
  (
    SELECT ce.PersonId, ul.UserId, p.ReverseName, 
      ROW_NUMBER() OVER (PARTITION BY ce.PersonId ORDER BY ce.EventNum DESC ) AS ReverseOrder, ce.EventTime
    FROM dbo.ClinEvent ce
    JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId                                 
    JOIN dbo.MetaStudyForm msf ON msf.FormId = cf.FormId AND msf.StudyId = @StudyId -- ENDO/NDV makes it necessary to use StudyId here and not on ClinEvent
    JOIN dbo.UserList ul ON ul.UserId = ce.CreatedBy 
    JOIN dbo.Person p ON p.PersonId = ul.PersonId
    JOIN dbo.MetaProfession mp ON mp.ProfId = ul.ProfId AND mp.ProfType IN ( 'LE','SP' )
  ) agg WHERE agg.ReverseOrder = 1;
  RETURN;
END
GO