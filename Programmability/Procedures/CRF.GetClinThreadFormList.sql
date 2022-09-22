SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetClinThreadFormList]( @StudyId INT, @PersonId INT ) AS
BEGIN
  --- Get forms
  SELECT ce.EventNum, ctf.FormId, ce.EventId, ce.EventTime, mf.FormTitle, mf.FormName,
    ctf.ThreadId, ct.ThreadName, ct.ThreadTypeId,
    ctf.ClinFormId, ctf.ItemId, ctf.FormStatus, ctf.FormComplete, ctf.CachedText, ct.SortOrder,
    mfs.StatusDesc, ctf.CreatedAt,
    up1.Signature AS CreatedBySign, ul1.ProfId AS CreatedByProfId, ctf.CreatedBy
  FROM dbo.ClinEvent ce
  JOIN dbo.ClinThread ct ON ct.EventId = ce.EventId  
  JOIN CRF.ClinThreadForm ctf ON ctf.ThreadId = ct.ThreadId
  JOIN dbo.MetaFormStatus mfs ON mfs.FormStatus = ctf.FormStatus
  JOIN dbo.MetaForm mf ON mf.FormId = ctf.FormId
  JOIN dbo.MetaStudyForm msf ON msf.FormId = ctf.FormId AND msf.StudyId = @StudyId
  LEFT JOIN dbo.UserList ul1 ON ul1.UserId = ctf.CreatedBy
  LEFT JOIN dbo.Person up1 ON up1.PersonId = ul1.PersonId
  LEFT JOIN dbo.MetaProfession mpc ON ul1.ProfId = mpc.ProfId
  WHERE ce.PersonId = @PersonId
  ORDER BY ctf.ClinFormId, ctf.ItemId, ct.SortOrder;
END
GO

GRANT EXECUTE ON [CRF].[GetClinThreadFormList] TO [FastTrak]
GO