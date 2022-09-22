SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetFormInstances]( @PersonId INT ) AS
BEGIN
  SELECT ce.PersonId,mf.FormName,COUNT(cf.ClinFormId) as FormCount,MAX(cf.CreatedAt) AS LastForm,MAX(cf.FormId) as LastFormId
  FROM dbo.ClinForm cf JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId     
  JOIN dbo.ClinEvent ce ON ce.EventId=cf.EventId 
  WHERE ce.PersonId=@PersonId
  GROUP BY ce.PersonId,mf.FormName;
END
GO

GRANT EXECUTE ON [report].[GetFormInstances] TO [FastTrak]
GO