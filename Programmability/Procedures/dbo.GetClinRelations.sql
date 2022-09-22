SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClinRelations]( @PersonId INT, @LookBack INT = 7 )
AS
BEGIN
  SELECT cr.RelId,mp.ProfName,pu.FullName,mr.RelName,CONVERT(VARCHAR,cr.CreatedAt,4) as CreatedAt,CONVERT(VARCHAR,cr.ExpiresAt,4) as ExpiresAt,
    ClinRelId 
  FROM ClinRelation cr 
  JOIN dbo.Person p ON p.PersonId=cr.PersonId
  JOIN dbo.UserList ul ON ul.UserId=cr.UserId
  JOIN dbo.Person pu ON pu.PersonId=ul.PersonId
  JOIN dbo.MetaRelation mr ON mr.RelId=cr.RelId
  JOIN dbo.MetaProfession mp ON mp.ProfId=ul.ProfId
  WHERE cr.PersonId=@PersonId AND ( cr.CreatedAt > getdate()-@Lookback or cr.ExpiresAt > getdate() - @Lookback );
END
GO

GRANT EXECUTE ON [dbo].[GetClinRelations] TO [FastTrak]
GO