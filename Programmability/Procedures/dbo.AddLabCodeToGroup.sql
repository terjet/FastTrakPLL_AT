SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddLabCodeToGroup]( @LabCodeId INT, @LabGroupId INT)
AS
BEGIN
  IF EXISTS( SELECT LabCodeId FROM dbo.LabCodeGroup WHERE LabGroupId=@LabGroupId AND LabCodeId=@LabCodeID)
     RETURN -1
  ELSE
    INSERT INTO dbo.LabCodeGroup (LabGroupId,LabCodeId) VALUES(@LabGroupId,@LabCodeId)
END
GO

GRANT EXECUTE ON [dbo].[AddLabCodeToGroup] TO [superuser]
GO