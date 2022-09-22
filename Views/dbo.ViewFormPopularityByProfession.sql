SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ViewFormPopularityByProfession] (StudyName, FormName, ProfType, UseCount, FirstUsed, LastUsed) 
AS
SELECT s.StudyName,mf.FormName,mp.ProfType,COUNT(cf.ClinFormId) as UseCount,MIN(ce.CreatedAt) as FirstUsed,MAX(ce.CreatedAt) as LastUsed 
  FROM ClinEvent ce   
  JOIN dbo.ClinForm cf ON cf.EventId=ce.EventId
  JOIN dbo.UserList ul ON cf.CreatedBy=ul.UserId
  JOIN dbo.MetaProfession mp ON mp.ProfId=ul.ProfId
  JOIN dbo.MetaForm mf ON mf.FormId=cf.FormId
  JOIN dbo.Study s ON s.StudyId=ce.StudyId
  WHERE ce.StudyId>0 AND cf.DeletedBy IS NULL
  GROUP BY s.StudyName,mf.FormName,mp.ProfType
GO

GRANT SELECT ON [dbo].[ViewFormPopularityByProfession] TO [FastTrak]
GO