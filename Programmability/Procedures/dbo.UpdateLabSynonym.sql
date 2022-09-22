SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateLabSynonym]( @OrigCodeId INT, @MapToCodeId INT ) AS
BEGIN
  SET XACT_ABORT ON; 
  UPDATE dbo.LabData SET OrigCodeId=@OrigCodeId WHERE LabCodeId=@OrigCodeId AND OrigCodeId IS NULL;
  UPDATE dbo.LabData SET LabCodeId=@MapToCodeId WHERE LabCodeId=@OrigCodeId OR OrigCodeId=@OrigCodeId;
  UPDATE dbo.LabCode SET SynonymId=@MapToCodeId WHERE LabCodeId=@OrigCodeId;
  INSERT INTO dbo.LabMapping (OrigCodeId,MapToCodeId) VALUES( @OrigCodeId,@MapToCodeId );
END
GO

DENY EXECUTE ON [dbo].[UpdateLabSynonym] TO [ReadOnly]
GO

GRANT EXECUTE ON [dbo].[UpdateLabSynonym] TO [superuser]
GO