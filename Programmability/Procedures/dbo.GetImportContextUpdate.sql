SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetImportContextUpdate]( @StudyName varchar(40), @ContextName varchar(64 ) )
AS BEGIN
  SELECT ISNULL(c.LastUpdate,0) AS LastUpdate 
  FROM ImportContext c JOIN Study s ON s.StudyId=c.StudyId AND StudyName=@StudyName
  WHERE ContextName=@ContextName;
END
GO

GRANT EXECUTE ON [dbo].[GetImportContextUpdate] TO [DataImport]
GO