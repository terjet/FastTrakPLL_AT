SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetAddisonPatientsUnspecifiedType]( @StudyId INT ) AS
BEGIN
  SELECT v.*,
  CASE ai.T6090 
    WHEN 99 THEN 'Andre typer'
    ELSE 'Uoppgitt type'
  END AS InfoText
  FROM Diagnose.AddisonInferred ai
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = ai.PersonId
  WHERE ISNULL(ai.T6090,0) IN ( 0,99 ) AND v.StudyId = @StudyId;
END
GO

GRANT EXECUTE ON [ROAS].[GetAddisonPatientsUnspecifiedType] TO [FastTrak]
GO