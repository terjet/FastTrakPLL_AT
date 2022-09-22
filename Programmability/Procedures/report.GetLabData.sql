SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[GetLabData]( @PersonId INT ) AS
BEGIN
  SET NOCOUNT ON;
  -- Retrieve labdata, latest first
  SELECT a.* FROM 
  (
    SELECT ld.PersonId, lc.VarName, ld.NumResult, ld.LabDate, ld.ResultId,
      RANK() OVER ( ORDER BY LabDate DESC ) AS OrderBy
    FROM dbo.LabData ld
      JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId
      JOIN dbo.LabClass la ON la.LabClassId = lc.LabClassId
    WHERE ( ld.PersonId = @PersonId ) AND ( la.TrustLevel > 2 )
  ) a
  WHERE a.OrderBy = 1;
END
GO

GRANT EXECUTE ON [report].[GetLabData] TO [superuser]
GO