SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddLabRequest]( @PersonId INT, @LabName VARCHAR(40)) AS
DECLARE @LabCodeId INT;
DECLARE @LabReqId INT;
/* Map the lab name to a LabCodeId */
SELECT @LabCodeId=ISNULL(SynonymId,LabCodeId) FROM LabCode WHERE LabName=@LabName;
/* Find lab request for this person, created by current user and still open */
SELECT @LabReqId=LabReqId FROM LabReq
  WHERE PersonId=@PersonId AND LabReqClosed=0 AND CreatedBy=USER_ID();
/* Add one if it doesn't exist */
IF @LabReqId IS NULL BEGIN
  INSERT INTO LabReq (PersonId) VALUES(@PersonId);
  SET @LabReqId=SCOPE_IDENTITY();
END;
/* Add lab test to this request */
INSERT INTO LabReqTest (LabReqId,LabCodeId) VALUES(@LabReqId,@LabCodeId);
GO