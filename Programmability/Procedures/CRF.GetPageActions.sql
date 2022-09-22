SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[GetPageActions]( @FormId INT ) AS
BEGIN
  SELECT mfa.MasterId, mfi.PageNumber, mfa.ComparisonType, mfa.PageConditionId, mfa.MasterEnumVal AS EnumVal 
  FROM dbo.MetaFormAction mfa
  JOIN dbo.MetaFormItem mfi ON mfi.FormId = mfa.FormId AND mfi.ItemId = mfa.DetailId
  WHERE mfa.FormId = @FormId
  ORDER BY mfi.PageNumber;
END;
GO

GRANT EXECUTE ON [CRF].[GetPageActions] TO [FastTrak]
GO