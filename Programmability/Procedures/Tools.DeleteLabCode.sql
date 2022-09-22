SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE procedure [Tools].[DeleteLabCode]( @LabCodeId INT )
AS
BEGIN
  IF ( SELECT COUNT(*) FROM LabData WHERE LabCodeId=@LabCodeId ) < 2 BEGIN
     DELETE FROM LabData WHERE LabCodeId=@LabCodeId;
     DELETE FROM LabCodeGroup WHERE LabCodeId=@LabCodeId;
     DELETE FROM LabCode WHERE LabCodeId=@LabCodeId;
  END
  ELSE
    RAISERROR( 'Too  many results to delete', 16, 1);
END
GO