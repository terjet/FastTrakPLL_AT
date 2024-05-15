SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [Comm].[OutboxForm] AS
SELECT 
  o.OutId,p.PersonId,p.DOB,p.Initials,p.ReverseName as PatientName,ce.EventTime,mf.FormTitle,cf.CreatedAt,cf.SignedAt,sp.Signature,
  o.CreatedAt as ExportedAt,
  o.PulledAt,CONVERT(FLOAT,o.PulledAt-o.CreatedAt)*24 as PullDelayHrs, 
  ISNULL(o.StatusCode,-2) AS StatusCode, ISNULL(m.StatusText,'Ubehandlet') as StatusText,
  o.StatusMessage

FROM COMM.Outbox o
JOIN dbo.ClinForm cf ON cf.ClinFormId=o.ClinFormId
JOIN dbo.ClinEvent ce ON ce.EventId=cf.EventId
JOIN dbo.Person p on p.PersonId=o.PersonId
LEFT OUTER JOIN dbo.UserList usp ON usp.UserId=cf.SignedBy 
LEFT OUTER JOIN dbo.Person sp ON sp.PersonId=usp.PersonId
JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId
LEFT OUTER JOIN Comm.MetaStatusCode m ON m.StatusCode=o.StatusCode
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [Comm].[OutboxForm] TO [public]
GO