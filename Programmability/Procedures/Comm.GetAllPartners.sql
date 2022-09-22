SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Comm].[GetAllPartners] AS
BEGIN
  SELECT p.PartnerId,p.PartnerName,o.OrgId,o.OrgName,ISNULL(p.HERId,o.HERId) as HERId,p.HPRNo 
  FROM Comm.Partner p JOIN Comm.Organization o ON o.OrgId=p.OrgId
END
GO