SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetMetaFormProfessionPrivileges] AS
BEGIN
  SELECT mp.ProfId, mfpp.FormId, mf.FormTitle, mfpp.ProfType, mp.ProfName, mfpp.CanCreate, mfpp.CanEdit, mfpp.CanSign	
  FROM dbo.MetaFormProfessionPrivilege mfpp
  JOIN dbo.MetaForm mf ON mf.FormId = mfpp.FormId
  JOIN dbo.MetaProfession mp ON mfpp.ProfType = mp.ProfType;
END;
GO