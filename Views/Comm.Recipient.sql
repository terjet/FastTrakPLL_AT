SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [Comm].[Recipient] AS
  SELECT p.PartnerId,p.PartnerName,o.OrgId,o.OrgName,ISNULL(p.HERId,o.HerId) as HERId,p.HPRNo 
  FROM Comm.Partner p JOIN Comm.Organization o ON o.OrgId=p.OrgId WHERE ISNULL(o.HERId,p.HERId) > 0;
GO

DENY
  DELETE,
  INSERT,
  UPDATE
ON [Comm].[Recipient] TO [public]
GO