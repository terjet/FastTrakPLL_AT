SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[GetAddisonPatientsWithStatus]( @StudyId INT ) AS
BEGIN
  SELECT p.PersonId, p.DOB, p.ReverseName AS FullName, p.DeceasedInd, p.NationalId, p.GenderId,
    CASE p.DeceasedInd 
      WHEN 0 THEN 'Levende'
      WHEN 1 THEN 'Død' 
    END AS GroupName,
    'Dødsdato: ' + CONVERT( VARCHAR, p.DeceasedDate, 104 ) AS InfoText
  FROM Diagnose.AddisonInferred ai
  JOIN dbo.Person p ON p.PersonId = ai.PersonId
  ORDER BY p.PersonId;
END
GO

GRANT EXECUTE ON [ROAS].[GetAddisonPatientsWithStatus] TO [FastTrak]
GO