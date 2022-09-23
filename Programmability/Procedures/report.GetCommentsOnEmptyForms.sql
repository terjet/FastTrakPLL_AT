SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetCommentsOnEmptyForms]( @StartTime DATETIME = NULL, @EndTime DATETIME = NULL ) AS
BEGIN
  SELECT @StartTime = ISNULL( @StartTime, DATEADD( DAY, -3650, GETDATE() ) )
  SELECT @EndTime = ISNULL( @EndTime,  GETDATE() )   
  SELECT TOP 200 ce.PersonId,cf.ClinFormId,cf.CreatedAt,mf.FormTitle,cf.Comment,p.Signature,ul.UserName 
  FROM dbo.ClinForm cf
  JOIN dbo.ClinEvent ce ON  ce.EventId=cf.EventId
  JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
  JOIN dbo.UserList ul ON ul.UserId  = cf.CreatedBy 
  JOIN Person p ON p.PersonId=ul.PersonId
  WHERE cf.FormComplete = 0 AND DATALENGTH(cf.Comment) > 5 AND cf.DeletedAt IS NULL
  AND cf.CreatedAt > @StartTime AND cf.CreatedAt < @EndTime
  ORDER by cf.ClinFormId DESC
END
GO

GRANT EXECUTE ON [report].[GetCommentsOnEmptyForms] TO [superuser]
GO