SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ViewLabReqPending] (PersonId, LabReqId, RequestedAt, RequestedBy, LabCodeId, TakenAt, TakenBy) 
AS
SELECT lr.PersonId,lr.LabReqId,lr.CreatedAt as RequestedAt, lr.CreatedBy as RequestedBy,
lrt.LabCodeId,lrt.TakenAt,lrt.TakenBy FROM dbo.LabReq lr
JOIN LabReqTest lrt on lrt.LabReqId=lr.LabReqId
WHERE lrt.LabDataId IS NULL
GO

GRANT SELECT ON [dbo].[ViewLabReqPending] TO [FastTrak]
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [dbo].[ViewLabReqPending] TO [public]
GO