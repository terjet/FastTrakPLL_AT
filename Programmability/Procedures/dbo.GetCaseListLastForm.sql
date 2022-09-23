SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListLastForm]( @StudyId INT, @FormName VARCHAR(24), @IgnoreDays FLOAT = 0 ) AS
BEGIN
  DECLARE @IgnoreFormsAfter DateTime;
  SET @IgnoreFormsAfter = GETDATE() - @IgnoreDays;
  SELECT v.*, 
      'Utfylt: ' + ISNULL(CONVERT(VARCHAR,forms.LastFormDate,104), 'Aldri') AS InfoText 
    FROM dbo.ViewActiveCaseListStub v
    LEFT JOIN
    (
      SELECT ce.PersonId, MAX(ce.EventTime) AS LastFormDate
      FROM dbo.ClinEvent ce
      JOIN dbo.ClinForm cf ON cf.EventId = ce.EventId AND cf.DeletedAt IS NULL
      JOIN dbo.MetaForm mf ON mf.FormId = cf.FormId AND mf.FormName = @FormName
      GROUP BY ce.PersonId 
    ) forms ON forms.PersonId = v.PersonId
  WHERE v.StudyId = @StudyId AND ( ( forms.LastFormDate <= @IgnoreFormsAfter ) OR ( forms.LastFormDate IS NULL ) )
  ORDER BY forms.LastFormDate;
END;
GO

GRANT EXECUTE ON [dbo].[GetCaseListLastForm] TO [FastTrak]
GO