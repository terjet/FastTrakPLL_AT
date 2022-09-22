SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClinFormHistory]( @ClinFormId INT ) AS
BEGIN
  SET NOCOUNT ON;
  SELECT f.Comment,f.CreatedAt,p.Signature FROM ClinFormLog f
    LEFT OUTER JOIN UserList ul ON ul.UserId=f.CreatedBy
    LEFT OUTER JOIN Person p on p.PersonId=ul.PersonId
  WHERE f.ClinFormId=@ClinFormId 
  ORDER BY f.CreatedAt DESC
END
GO

GRANT EXECUTE ON [dbo].[GetClinFormHistory] TO [FastTrak]
GO