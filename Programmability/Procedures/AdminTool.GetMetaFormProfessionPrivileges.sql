SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [AdminTool].[GetMetaFormProfessionPrivileges] (@ProfType VARCHAR(3)) AS
BEGIN
	SELECT *
	FROM dbo.MetaFormProfessionPrivilege mfpp
	JOIN dbo.MetaForm mf ON mf.FormId = mfpp.FormId
	WHERE mfpp.ProfType = @ProfType
END;
GO