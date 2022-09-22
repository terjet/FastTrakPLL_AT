SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateLabCodeGroup]( @LabName VARCHAR(40), @AddToGroupId INT, @RemoveFromGroupId INT ) AS
BEGIN
  DECLARE @LabCodeId INT;
  SELECT @LabCodeId=LabCodeId FROM dbo.LabCode WHERE LabName = @LabName;
  IF @LabCodeId IS NULL 
  BEGIN
    INSERT INTO dbo.LabCode (LabName) VALUES( @LabName );
    SET @LabCodeId=SCOPE_IDENTITY();
  END
  ELSE
    DELETE FROM dbo.LabCodeGroup WHERE LabGroupId=@RemoveFromGroupId AND LabCodeId=@LabCodeId;
  IF ISNULL( @AddToGroupId, 0 ) > 0
    INSERT INTO dbo.LabCodeGroup (LabGroupId,LabCodeId) VALUES( @AddToGroupId, @LabCodeId );
END
GO