SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[GetCaseListMyPendingProms]( @StudyId INT ) AS
BEGIN
  SET LANGUAGE 'Norwegian';
  SELECT v.*, mf.FormTitle + ', frist: ' + CONVERT(VARCHAR,fo.ExpiryDate,104) AS InfoText
  FROM PROM.FormOrder fo
  JOIN dbo.MetaForm mf ON mf.FormId=fo.FormId
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = fo.PersonId AND StudyId = @StudyId
  WHERE fo.ClinFormId IS NULL AND fo.CreatedBy = USER_ID()
  ORDER BY fo.CreatedAt DESC;
END
GO

GRANT EXECUTE ON [PROM].[GetCaseListMyPendingProms] TO [FastTrak]
GO