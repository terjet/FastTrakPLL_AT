SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetShortConsWithHbA1c]( @StudyId INT ) AS
BEGIN
  SELECT v.*,a.ShortConsCount,hba1c.NumResult, 
    'HbA1c=' + CONVERT(VARCHAR,hbA1c.NumResult ) + ', Kortkonsultasjoner n = ' + CONVERT(VARCHAR,ShortConsCount) + '.' AS InfoText
  FROM 
  dbo.ViewActiveCaseListStub v
  JOIN dbo.GetLastLabDataTable( 1058, '3000-01-01' ) hba1c ON hba1c.PersonId = v.PersonId
  JOIN (
    SELECT ce.PersonId,count(*) AS ShortConsCount 
    FROM dbo.ClinForm cf 
    JOIN dbo.MetaForm mf on mf.FormId = cf.FormId
    JOIN dbo.ClinEvent ce ON ce.EventId=cf.EventId
    WHERE mf.FormName = 'DIAPOL_SHORT' AND cf.DeletedAt IS NULL 
    GROUP BY ce.PersonId
   ) a
  ON a.PersonId = v.PersonId
  WHERE v.StudyId=@StudyId
  ORDER BY NumResult DESC;
END
GO

GRANT EXECUTE ON [NDV].[GetShortConsWithHbA1c] TO [FastTrak]
GO