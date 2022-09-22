SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetClinFormList] (@StudyId INT, @PersonId INT, @IncludeArchived BIT) AS
BEGIN
  -- Log reads
  INSERT INTO dbo.CaseLog (PersonId, LogType, LogText)
    VALUES (@PersonId, 'LESE', 'Journal lest av ' + USER_NAME());
  --- Get forms
  SELECT ce.EventNum, cf.FormId, ce.EventId, ce.EventTime, mf.FormTitle, mf.FormName,
    cf.ClinFormId, cf.FormStatus, cf.FormComplete, cf.Comment, cf.CachedText,
    mfs.StatusDesc, cf.CreatedAt, cf.SignedAt, cf.Archived,
    up1.Signature AS CreatedBySign, ul1.ProfId AS CreatedByProfId, cf.CreatedBy,
    up2.Signature AS SignedBySign, ul2.ProfId AS SignedByProfId, cf.SignedBy,
    COALESCE(mpsh.ProfName, '?'+mps.ProfName) AS SignedByProfNameHistoric,
    COALESCE(mpch.ProfName, '?'+mpc.ProfName) AS CreatedByProfNameHistoric
  FROM dbo.ClinEvent ce
  JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND (cf.DeletedAt IS NULL)
  JOIN dbo.MetaFormStatus mfs ON mfs.FormStatus = cf.FormStatus
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
  JOIN dbo.MetaStudyForm msf ON msf.FormId = cf.FormId AND msf.StudyId = @StudyId
  LEFT JOIN dbo.UserList ul1 ON ul1.UserId = cf.CreatedBy
  LEFT JOIN dbo.UserList ul2 ON ul2.UserId = cf.SignedBy
  LEFT JOIN dbo.Person up1 ON up1.PersonId = ul1.PersonId
  LEFT JOIN dbo.Person up2 ON up2.PersonId = ul2.PersonId
  LEFT JOIN dbo.UserLog ulo ON cf.CreatedSessId = ulo.SessId
  LEFT JOIN dbo.MetaProfession mpch ON ulo.ProfId = mpch.ProfId
  LEFT JOIN dbo.MetaProfession mpc ON ul1.ProfId = mpc.ProfId
  LEFT JOIN dbo.UserLog ulo2 ON cf.SignedSessId = ulo2.SessId
  LEFT JOIN dbo.MetaProfession mpsh on ulo2.ProfId = mpsh.ProfId
  LEFT JOIN dbo.MetaProfession mps on ul2.ProfId = mps.ProfId
  WHERE (ce.PersonId = @PersonId) AND ((cf.Archived = 0) OR (@IncludeArchived = 1));
END
GO