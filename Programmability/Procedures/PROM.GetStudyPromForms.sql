SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[GetStudyPromForms]( @StudyId INT, @IncludeExpired BIT = 0 ) AS
BEGIN
  -- Returns a list for forms that can (or could) be requested from the patient for a given StudyId.
  SELECT mf.FormId, ISNULL( msf.FormTitle, mf.FormTitle ) AS FormTitle, fm.PromUid, fm.ExpireDays, fm.ValidFrom, fm.ValidUntil
  FROM PROM.FormMapping fm 
    JOIN dbo.MetaForm mf ON mf.FormId = fm.FormId
    JOIN dbo.MetaStudyForm msf ON msf.FormId = mf.FormId
  WHERE ( msf.StudyId = @StudyId ) AND ( ( @IncludeExpired = 1 ) OR ( GETDATE() BETWEEN fm.ValidFrom AND fm.ValidUntil ) );
END
GO