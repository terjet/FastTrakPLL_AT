SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateLabGroupMoveDown]( @LabGroupId INT ) AS
DECLARE @SortOrder INT;
DECLARE @NewOrder INT;
SELECT @SortOrder = SortOrder FROM LabGroup WHERE LabGroupId=@LabGroupId;
IF ISNULL(@SortOrder,0) > 1
BEGIN
  SELECT @NewOrder = MIN(SortOrder) FROM LabGroup WHERE SortOrder > @SortOrder;
  UPDATE LabGroup SET SortOrder = @SortOrder WHERE SortOrder=@NewOrder;
  UPDATE LabGroup SET SortOrder = @NewOrder WHERE LabGroupId=@LabGroupId;
END
GO

DENY EXECUTE ON [dbo].[UpdateLabGroupMoveDown] TO [ReadOnly]
GO

GRANT EXECUTE ON [dbo].[UpdateLabGroupMoveDown] TO [superuser]
GO