SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListByFormName] ( @StudyId INT, @FormName VARCHAR(32) )
AS
BEGIN
  SELECT p.PersonId,p.DOB,p.FullName,p.GroupName,
    'Siste: ' + CONVERT(VARCHAR,max(ce.EventTime),104) as InfoText
  FROM ViewCaseListStub p
  JOIN ClinEvent ce ON ce.PersonId=p.PersonId
  JOIN ClinForm cf ON cf.EventId=ce.EventId
  JOIN MetaForm mf ON mf.FormId=cf.FormId
  WHERE ( mf.FormName=@FormName ) AND ( cf.DeletedAt IS NULL ) AND ( p.StudyId=@StudyId )
  GROUP BY p.PersonId,p.DOB,p.FullName,p.GroupName
  ORDER BY p.FullName
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListByFormName] TO [FastTrak]
GO