SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[RecodeFormEnumItem]( @FormId INT, @OldItemId INT, @OldEnumVal INT, @NewItemId INT, @NewEnumVal INT) AS
BEGIN
  UPDATE dbo.MetaFormItem SET ItemId = @NewItemId WHERE FormId=@FormId AND ItemId=@OldItemId ;
  UPDATE dbo.ClinDatapoint SET ItemId=@NewItemId,EnumVal=@NewEnumVal,Quantity=@NewEnumVal 
  WHERE ( ItemId=@OldItemId ) AND ( EnumVal=@OldEnumVal ) AND ( ( @FormId = 0 ) OR ( EventId IN ( SELECT EventId FROM ClinForm WHERE FormId=@FormId ) ) ) 
  AND ( NOT EventId IN ( SELECT EventId FROM dbo.ClinDatapoint WHERE ItemId=@NewItemId) );
END
GO