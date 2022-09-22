SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateLabClassId]( @LabCodeId INT, @LabClassId INT ) AS
BEGIN
  IF @LabClassId = 0 SET @LabClassId=NULL;
  UPDATE dbo.LabCode SET LabClassId=NULLIF(@LabClassId,0) WHERE LabCodeId=@LabCodeId;
  -- Copy VarName field
  UPDATE dbo.LabCode SET VarName = ( SELECT VarName FROM dbo.LabClass WHERE LabClassId=LabCode.LabClassId )
    WHERE LabCodeId=@LabCodeId;
END
GO

GRANT EXECUTE ON [dbo].[UpdateLabClassId] TO [FastTrak]
GO

DENY EXECUTE ON [dbo].[UpdateLabClassId] TO [ReadOnly]
GO