SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateLabTestGroup]( @LabCodeId INT, @AddToGroupId INT, @RemoveFromGroupId INT ) AS
BEGIN
  -- Delete from existing group
  DELETE FROM dbo.LabCodeGroup WHERE LabGroupId=@RemoveFromGroupId AND LabCodeId=@LabCodeId;
  -- Add to new group
  IF ( ISNULL( @AddToGroupId, 0 ) > 0 ) AND NOT 
  EXISTS( SELECT LabCodeId FROM dbo.LabCodeGroup WHERE LabCodeId=@LabCodeId AND LabGroupId=@AddToGroupId )
    INSERT INTO dbo.LabCodeGroup (LabGroupId,LabCodeId) VALUES( @AddToGroupId, @LabCodeId );
END
GO

GRANT EXECUTE ON [dbo].[UpdateLabTestGroup] TO [superuser]
GO