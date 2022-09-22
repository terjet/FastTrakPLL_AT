SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetFormClasses]( @StudyId INT ) AS
BEGIN
  SELECT DISTINCT mf.FormName,msf.FormTitle 
  FROM dbo.MetaForm mf JOIN dbo.MetaStudyForm msf ON msf.FormId=mf.FormId 
  WHERE NOT FormName LIKE 'FORM%'
  AND msf.StudyId=@StudyId;
END
GO

GRANT EXECUTE ON [report].[GetFormClasses] TO [superuser]
GO