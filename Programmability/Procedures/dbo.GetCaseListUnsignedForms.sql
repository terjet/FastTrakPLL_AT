SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListUnsignedForms]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, mf.FormTitle + ', ' + dbo.LongTime( ce.EventTime) as InfoText
  FROM ViewActiveCaseListStub v
    JOIN dbo.ClinEvent ce ON ce.PersonId=v.PersonId
    JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId AND cf.CreatedBy = user_id() AND cf.SignedAt IS NULL and cf.DeletedAt IS NULL
    JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId
    WHERE v.StudyId=@StudyId
  ORDER BY ce.EventTime
END
GO