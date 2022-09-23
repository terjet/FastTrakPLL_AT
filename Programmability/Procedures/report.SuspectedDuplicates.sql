SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [report].[SuspectedDuplicates] AS
BEGIN

  -- Generate a list with pairs of individuals that may be duplicates of one another.

  SELECT 
    candidates.DOB, 
    candidates.PID1, 
    candidates.PID2, 
    p1.ReverseName AS Name1, 
    p2.ReverseName AS Name2, 
    p1.NationalId AS NatId1, 
    p2.NationalId AS NatId2,
    p1.EmployeeNumber AS Emp1, 
    p2.EmployeeNumber AS Emp2,
    p1.HPRNo AS Hpr1, 
    p2.HPRNo AS Hpr2
  INTO #candidates
  FROM
  (
      SELECT 
        MIN(PersonId) AS PID1, MAX(PersonId) AS PID2,
        CONVERT(DATE,DOB) AS DOB
      FROM dbo.Person 
        WHERE FstName <> 'Duplikat'
        GROUP BY DOB, FstName
        HAVING COUNT(*) = 2
      UNION
      SELECT 
        MIN(PersonId) AS PID1, MAX(PersonId) AS PID2,
        CONVERT(DATE,DOB) AS DOB
      FROM dbo.Person
        WHERE FstName <> 'Duplikat'
        GROUP BY DOB, LstName
        HAVING COUNT(*) = 2
  ) candidates
  JOIN dbo.Person p1 ON p1.PersonId = candidates.PID1
  JOIN dbo.Person p2 ON p2.PersonId = candidates.PID2
  WHERE 
   ( p1.GenderId = p2.GenderId OR p1.GenderId = 0 OR p2.GenderId = 0 ) AND 
   ( ISNULL( p1.NationalId, '' ) = ''   OR ISNULL( p2.NationalId, '' ) = '' ) AND
   ( ISNULL( p1.HPRNo, 0 ) = 0          OR ISNULL( p2.HPRNo, 0 ) = 0  ) AND
   ( ISNULL( p1.EmployeeNumber, 0 ) = 0 OR ISNULL( p2.EmployeeNumber, 0 ) = 0  );

-- Now count the datapoints associated with the candidates, to give an indication of how straightforward it is to fix this problem.

  SELECT agg.*, 
    CE1+LD1+PC1 AS Tot1, 
    CE2+LD2+PC2 AS Tot2
  FROM
  (
    SELECT c.*, 
      ( SELECT COUNT(*) FROM dbo.UserList     WHERE PersonId = c.PID1 ) AS UL1,
      ( SELECT COUNT(*) FROM dbo.UserList     WHERE PersonId = c.PID2 ) AS UL2,
      ( SELECT COUNT(*) FROM dbo.ClinEvent    WHERE PersonId = c.PID1 ) AS CE1,
      ( SELECT COUNT(*) FROM dbo.ClinEvent    WHERE PersonId = c.PID2 ) AS CE2,
      ( SELECT COUNT(*) FROM dbo.LabData      WHERE PersonId = c.PID1 ) AS LD1,
      ( SELECT COUNT(*) FROM dbo.LabData      WHERE PersonId = c.PID2 ) AS LD2,
      ( SELECT COUNT(*) FROM Pandemic.Contact WHERE IndexPersonId = c.PID1 OR ContactPersonId = c.PID1 ) AS PC1,
      ( SELECT COUNT(*) FROM Pandemic.Contact WHERE IndexPersonId = c.PID2 OR ContactPersonId = c.PID2 ) AS PC2
    FROM #candidates c
  ) agg;

END
GO

GRANT EXECUTE ON [report].[SuspectedDuplicates] TO [Administrator]
GO