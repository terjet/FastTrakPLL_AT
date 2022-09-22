SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLabReqTestPending]( @PersonId INT ) AS
BEGIN
  SELECT lrt.LabCodeId, lc.LabName FROM dbo.LabReq lr
  JOIN dbo.LabReqTest lrt on lrt.LabReqId=lr.LabReqId
  JOIN dbo.LabCode lc ON lc.LabCodeId=lrt.LabCodeId
  WHERE lrt.LabDataId IS NULL AND lr.PersonId=@PersonId
END
GO