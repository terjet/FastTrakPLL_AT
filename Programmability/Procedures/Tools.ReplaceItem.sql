SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[ReplaceItem]( @OldItemId INT, @NewItemId INT ) AS
BEGIN
  SET NOCOUNT ON;
  UPDATE dbo.MetaFormItem SET ItemId = @NewItemId WHERE ItemId = @OldItemId;
  UPDATE dbo.ClinDatapoint SET ItemId = @NewItemId WHERE ( ItemId = @OldItemId ) 
  AND ( NOT EventId IN ( SELECT EventId FROM dbo.ClinDatapoint WHERE ItemId=@NewItemId) );
END
GO