SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetClinForm]( @ClinFormId INT ) AS
BEGIN
  SELECT e.EventNum, cf.FormId, e.EventId, e.EventTime, mf.FormTitle, mf.FormName,
    cf.ClinFormId, cf.FormStatus, cf.FormComplete, cf.Comment, cf.CachedText,
    mfs.StatusDesc, cf.CreatedAt, cf.SignedAt, cf.Archived, cf.LastTouchId,
    up1.Signature AS CreatedBySign, cf.CreatedBy, ul1.ProfId AS CreatedByProfId,
    up2.Signature AS SignedBySign, cf.SignedBy, ul2.ProfId AS SignedByProfId,
    COALESCE(mpsh.ProfName, mps.ProfName + '(?)' ) AS SignedByProfNameHistoric,
    COALESCE(mpch.ProfName, mpc.ProfName + '(?)' ) AS CreatedByProfNameHistoric
  FROM dbo.ClinEvent e
    JOIN dbo.ClinForm cf on cf.EventId=e.EventId
    JOIN dbo.MetaFormStatus mfs ON mfs.FormStatus=cf.FormStatus
    LEFT JOIN dbo.MetaForm mf on mf.FormId=cf.FormId
    LEFT JOIN dbo.UserList ul1 ON ul1.UserId=cf.CreatedBy
    LEFT JOIN dbo.Person up1 ON up1.PersonId=ul1.PersonId
    LEFT JOIN dbo.UserList ul2 ON ul2.UserId=cf.SignedBy
    LEFT JOIN dbo.Person up2 ON up2.PersonId=ul2.PersonId
    LEFT JOIN dbo.UserLog ulo ON cf.CreatedSessId = ulo.SessId
    LEFT JOIN dbo.MetaProfession mpch ON ulo.ProfId = mpch.ProfId
    LEFT JOIN dbo.MetaProfession mpc ON ul1.ProfId = mpc.ProfId
    LEFT JOIN dbo.UserLog ulo2 ON cf.SignedSessId = ulo2.SessId
    LEFT JOIN dbo.MetaProfession mpsh on ulo2.ProfId = mpsh.ProfId
    LEFT JOIN dbo.MetaProfession mps on ul2.ProfId = mps.ProfId
  WHERE ClinFormId=@ClinFormId;
END
GO

GRANT EXECUTE ON [CRF].[GetClinForm] TO [FastTrak]
GO