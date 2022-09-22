SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLabDataStudy]( @StudyId INT )
AS
BEGIN
  SELECT ld.PersonId,ld.LabDate,ld.LabCodeId,lc.LabName,ld.NumResult
  FROM LabData ld JOIN LabCode lc on lc.LabCodeId=ld.LabCodeId
  JOIN StudCase sc on sc.PersonId=ld.PersonId AND sc.StudyId=@StudyId
END;
GO

GRANT EXECUTE ON [dbo].[GetLabDataStudy] TO [FastTrak]
GO