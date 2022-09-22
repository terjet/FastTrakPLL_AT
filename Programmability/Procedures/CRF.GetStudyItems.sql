SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetStudyItems]( @StudyId INT ) AS
BEGIN
  SELECT DISTINCT mi.ItemId,mi.VarName,mi.ItemType,mi.UnitStr,mi.LabName,mi.ThreadTypeId 
    FROM MetaItem mi 
    JOIN MetaFormItem mfi ON mfi.ItemId=mi.ItemId 
	JOIN MetaStudyForm ms ON ms.FormId=mfi.FormId AND ms.StudyId=@StudyId
	ORDER BY mi.ItemId
END
GO