SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [BDR].[GetRecentStablePatientsTable] ( @CutoffDate DATETIME, @ConsultationLookBehindMonths INT, @DiagnosisPeriod INT )
  RETURNS @PersonList TABLE ( PersonId INT NOT NULL PRIMARY KEY ) AS
BEGIN
  INSERT INTO @PersonList
    SELECT DISTINCT ce1.PersonId
      FROM dbo.ClinEvent ce1
         JOIN dbo.ClinForm cf ON cf.EventId = ce1.EventId
         JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
         JOIN dbo.StudyGroup sg ON sg.StudyId = ce1.StudyId AND sg.GroupId = ce1.GroupId AND sg.GroupActive = 1
         JOIN dbo.UserList ul ON ul.UserId = USER_ID() AND ul.CenterId = sg.CenterId
         JOIN dbo.ClinEvent ce2 ON ce2.StudyId = ce1.StudyId AND ce2.PersonId = ce1.PersonId
         JOIN dbo.ClinDataPoint cdp2 ON cdp2.EventId = ce2.EventId
    WHERE ( mf.FormName IN ( 'BDIA_BASIC', 'BDIA_VISIT' ) OR mf.FormName LIKE 'BDR_YEAR%' )
       AND ce1.EventTime BETWEEN DATEADD(MONTH, -@ConsultationLookBehindMonths , @CutoffDate) AND @CutoffDate
       AND cdp2.ItemId = 3323 AND cdp2.DTVal < DATEADD(MONTH, -@DiagnosisPeriod, ce1.EventTime)
    ORDER BY ce1.PersonId;
  RETURN;
END
GO

GRANT SELECT ON [BDR].[GetRecentStablePatientsTable] TO [Administrator]
GO

GRANT SELECT ON [BDR].[GetRecentStablePatientsTable] TO [QuickStat]
GO