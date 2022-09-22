SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Comm].[GetPersonPartners]( @PersonId INT ) AS
BEGIN
    SELECT DISTINCT p.PartnerId,p.PartnerName,o.OrgId,o.OrgName,ISNULL(p.HERId,o.HerId) as HerId,p.HPRNo 
    FROM Comm.Partner p JOIN Comm.Organization o ON o.OrgId=p.OrgId 
    JOIN Comm.Outbox ob ON ob.PartnerId=p.PartnerId AND ob.PersonId=@PersonId
    WHERE ISNULL(o.HerId,p.HerId) > 0;
END
GO

GRANT EXECUTE ON [Comm].[GetPersonPartners] TO [FastTrak]
GO