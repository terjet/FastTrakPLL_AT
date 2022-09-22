﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[ReplaceFormItem]( @FormId INT, @OldItemId INT, @NewItemId INT ) AS
BEGIN
  UPDATE dbo.MetaFormItem SET ItemId = @NewItemId WHERE FormId=@FormId AND ItemId=@OldItemId ;
  UPDATE dbo.ClinDatapoint SET ItemId=@NewItemId WHERE ( ItemId=@OldItemId ) 
  AND ( ( @FormId = 0 ) OR ( EventId IN ( SELECT EventId FROM ClinForm WHERE FormId=@FormId ) ) ) 
  AND ( NOT EventId IN ( SELECT EventId FROM dbo.ClinDatapoint WHERE ItemId=@NewItemId) );
END
GO