SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateLabSynonymUndo]( @LabCodeId INT ) AS
BEGIN
  SET XACT_ABORT ON; 
  UPDATE dbo.LabData SET LabCodeId=@LabCodeId WHERE OrigCodeId=@LabCodeId;
  UPDATE dbo.LabCode SET VarName=NULL, SynonymId=NULL WHERE LabCodeId=@LabCodeId;
  INSERT INTO dbo.LabMapping (OrigCodeId,MapToCodeId) VALUES( @LabCodeId,NULL );
END
GO

DENY EXECUTE ON [dbo].[UpdateLabSynonymUndo] TO [ReadOnly]
GO

GRANT EXECUTE ON [dbo].[UpdateLabSynonymUndo] TO [superuser]
GO