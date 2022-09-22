SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[MoveAndDeleteLabCode]( @LabCodeId INT, @NewLabCodeId INT )
AS
BEGIN
  IF ( SELECT COUNT(*) FROM LabData WHERE LabCodeId=@LabCodeId ) < 2 BEGIN
    UPDATE LabData SET LabCodeId=@NewLabCodeId,OrigCodeId=@NewLabCodeId WHERE LabCodeId=@LabCodeId;
    UPDATE LabData SET OrigCodeId=@NewLabCodeId WHERE OrigCodeId=@LabCodeId;
    DELETE FROM LabCodeGroup WHERE LabCodeId=@LabCodeId;
    DELETE FROM LabCode WHERE LabCodeId=@LabCodeId;
  END
  ELSE
    RAISERROR( 'Too  many results to delete', 16, 1);
END;
GO