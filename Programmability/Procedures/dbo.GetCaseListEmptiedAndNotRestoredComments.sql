SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListEmptiedAndNotRestoredComments] ( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, CurrentComment.ClinFormId, v.FullName, v.GenderId,  mf.FormTitle AS GroupName, CurrentComment.CreatedAt AS InfoText,
    CurrentComment.Comment AS CurrentComment, PreviousComment.Comment AS PreviousComment,
    CurrentComment.CreatedAt AS CurrentCommentCreatedAt, ce.EventTime AS FormDate, CurrentComment.CreatedBy AS FormCreatedBy, CurrentComment.SignedBy AS FormSignedBy FROM
    ( 
      SELECT cf.* FROM dbo.ClinForm cf
      WHERE cf.DeletedAt IS NULL AND cf.Comment = ''
    ) CurrentComment
  JOIN
    (
      SELECT * FROM (
        SELECT cl.ClinFormId, cl.CreatedAt, cl.CreatedBy, cl.Comment, ROW_NUMBER() OVER ( PARTITION BY cl.ClinFormId ORDER BY cl.CreatedAt DESC ) AS ReverseOrder FROM dbo.ClinFormLog cl
        WHERE cl.CreatedAt >= '2020' -- år kjent feil blei introdusert
    ) subquery
      WHERE subquery.ReverseOrder = 1 AND subquery.Comment <> '' ) PreviousComment
        ON CurrentComment.ClinFormId = PreviousComment.ClinFormId
  JOIN dbo.MetaForm mf ON mf.FormId = CurrentComment.FormId
  JOIN dbo.ClinEvent ce ON ce.EventId = CurrentComment.EventId AND ce.StudyId = @StudyId
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = ce.PersonId AND v.StudyId = @StudyId
  ORDER BY PreviousComment.CreatedAt
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListEmptiedAndNotRestoredComments] TO [FastTrak]
GO