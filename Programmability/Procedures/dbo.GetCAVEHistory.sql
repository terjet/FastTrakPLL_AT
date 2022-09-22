SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCAVEHistory]( @PersonId INT ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT Content,
    CASE pdl.DocumentId 
      WHEN 50001 THEN 'CAVE'
      WHEN 50003 THEN 'Ønsker'
      WHEN 50005 THEN 'NB'
      WHEN 11036 THEN 'Allergi'
    ELSE
      'Annet'
    END AS Section,
    up.Signature,ChangedAt,ChangedBy
  FROM dbo.PersonDocumentLog pdl 
    LEFT OUTER JOIN dbo.UserList ul ON ul.UserId=pdl.ChangedBy
    LEFT OUTER JOIN dbo.Person up on up.PersonId=ul.PersonId
  WHERE pdl.PersonId=@PersonId
  ORDER BY ChangedAt DESC
END
GO

GRANT EXECUTE ON [dbo].[GetCAVEHistory] TO [FastTrak]
GO