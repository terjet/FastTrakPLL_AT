SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [PROM].[GetCaseListMyCompletedProms]( @StudyId INT ) AS
BEGIN
  SET LANGUAGE 'Norwegian';
  SELECT v.*, 
    mf.FormTitle + ', ' + CONVERT(VARCHAR,cf.FormComplete) + '% komplett, utfylt ' + CONVERT(VARCHAR,EventTime,104) + '.' AS InfoText 
  FROM PROM.FormOrder fo
  JOIN dbo.MetaForm mf ON mf.FormId=fo.FormId
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = fo.PersonId AND StudyId = @StudyId
  JOIN dbo.ClinForm cf ON cf.ClinFormId = fo.ClinFormId
  JOIN dbo.ClinEvent ce ON ce.EventId = cf.EventId
  WHERE fo.CreatedBy = USER_ID()
  ORDER BY fo.CreatedAt DESC;
END
GO

GRANT EXECUTE ON [PROM].[GetCaseListMyCompletedProms] TO [FastTrak]
GO