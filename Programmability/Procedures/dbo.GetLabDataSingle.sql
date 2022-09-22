SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLabDataSingle] ( @PersonId INT, @LabName VARCHAR(40) ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT ResultId,LabDate,ld.NumResult
  FROM LabData ld JOIN dbo.LabCode lc on lc.LabCodeId=ld.LabCodeId AND lc.LabName=@LabName
  WHERE ld.PersonId=@PersonId
END
GO

GRANT EXECUTE ON [dbo].[GetLabDataSingle] TO [FastTrak]
GO