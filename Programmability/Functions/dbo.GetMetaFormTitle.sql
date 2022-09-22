SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetMetaFormTitle]( @StudyId INT, @FormName VARCHAR(24) )
RETURNS VARCHAR(128) AS
BEGIN
  RETURN (SELECT TOP 1
      msf.FormTitle
    FROM dbo.MetaStudyForm msf
    LEFT JOIN dbo.MetaForm mf
      ON mf.FormId = msf.FormId
    WHERE mf.FormName = @FormName
    AND msf.StudyId = @StudyId
    ORDER BY mf.FormId DESC, msf.FormActive DESC);
END;
GO