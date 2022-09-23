SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[GetCaseListHbA1cProject2017] (@StudyId INT) AS
BEGIN
  SET LANGUAGE Norwegian;
  
  -- Get latest labdata from forms
  EXEC NDV.MergeHba1cToLabdata;

  SELECT rp.PersonId,
    p.DOB, p.ReverseName AS FullName, ISNULL(ss.StatusText, '(ukjent)') AS GroupName, p.NationalId, p.GenderId,
    ld.NumResult AS HbA1c, ld.LabDate,
    CASE
      WHEN ld.NumResult IS NOT NULL THEN 'HbA1c = ' + CONVERT(VARCHAR, ld.NumResult) + ', tatt ' + CONVERT(VARCHAR, ld.LabDate, 104)
      ELSE 'HbA1c ikke målt'
    END AS InfoText
  FROM NDV.GetRecentPatientsTable(1, '2017-01-01', 15) rp
  LEFT JOIN dbo.GetLastLabDataTable( 1058, '3000-01-01') ld ON ld.PersonId = rp.PersonId
  JOIN dbo.Person p ON p.PersonId = rp.PersonId
  JOIN dbo.Study s ON s.StudyName = 'NDV'
  LEFT JOIN dbo.StudCase sc ON sc.StudyId = s.StudyId AND sc.PersonId = p.PersonId
  LEFT JOIN dbo.StudyStatus ss ON ss.StudyId = sc.StudyId AND ss.StatusId = sc.FinState
  ORDER BY ld.NumResult DESC, p.ReverseName;
END
GO

GRANT EXECUTE ON [NDV].[GetCaseListHbA1cProject2017] TO [FastTrak]
GO