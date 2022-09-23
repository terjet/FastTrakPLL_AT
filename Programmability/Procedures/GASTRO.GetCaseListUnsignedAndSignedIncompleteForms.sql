SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GASTRO].[GetCaseListUnsignedAndSignedIncompleteForms] (@StudyId INT) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName,
    CASE
      WHEN cf.SignedAt IS NULL THEN 'Usignert'
      ELSE 'Signert ukomplett'
    END + ', ' +
                CASE mf.FormName
                  WHEN 'SCREENINGKOLOSKOPI' THEN 'Screening'
                  WHEN 'KLINISK_KOLOSKOPI' THEN 'Klinisk'
                END
    + ', ' + dbo.LongTime(ce.EventTime) AS InfoText
  FROM dbo.ViewActiveCaseListStub v
  JOIN dbo.ClinEvent ce ON ce.PersonId = v.PersonId AND ce.StudyId = @StudyId
  JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
  WHERE v.StudyId = @StudyId
  AND (cf.SignedAt IS NULL OR (mf.FormName = 'SCREENINGKOLOSKOPI' AND ISNULL(cf.
      FormCompleteRequired, 0) < 100))
  ORDER BY ce.EventTime DESC;
END
GO

GRANT EXECUTE ON [GASTRO].[GetCaseListUnsignedAndSignedIncompleteForms] TO [FastTrak]
GO