SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetStudyFormItems]( @StudyId INT )
AS
BEGIN
  SELECT mfi.FormId,mfi.ItemId,mfi.OrderNumber,mfi.ItemHeader,mfi.ItemText,mi.VarName,mi.UnitStr,mi.ItemType,
    mfi.MinExpression,mfi.MaxExpression, mfi.Decimals, mfi.FormItemId  
  FROM MetaFormItem mfi 
  JOIN MetaItem mi ON mi.ItemId=mfi.ItemId
  JOIN MetaStudyForm msf ON msf.FormId=mfi.FormId
  WHERE msf.StudyId=@StudyId
END
GO

GRANT EXECUTE ON [CRF].[GetStudyFormItems] TO [FastTrak]
GO