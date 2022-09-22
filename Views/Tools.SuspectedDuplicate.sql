SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [Tools].[SuspectedDuplicate] AS

  SELECT DOB, PID1, PID2, Name1, Name2, NatId1, NatId2, CE1, CE2, LD1, LD2
  FROM 

  ( 
      
    -- Duplicates DOB/LastName
    
    SELECT dup1.*, 
      p1.ReverseName AS Name1, p2.ReverseName AS Name2,
      p1.NationalId AS NatId1, p2.NationalId AS NatId2,
      ( SELECT COUNT(*) FROM dbo.ClinEvent WHERE PersonId = dup1.PID1 ) AS CE1,
      ( SELECT COUNT(*) FROM dbo.ClinEvent WHERE PersonId = dup1.PID2 ) AS CE2,
      ( SELECT COUNT(*) FROM dbo.LabData WHERE PersonId = dup1.PID1 ) AS LD1,
      ( SELECT COUNT(*) FROM dbo.LabData WHERE PersonId = dup1.PID2 ) AS LD2
    FROM  
    (
      SELECT 
        CONVERT(DATE,DOB) AS DOB,
        MIN(PersonId) AS PID1, MAX(PersonId) AS PID2
      FROM dbo.Person
      GROUP BY DOB,LstName
      HAVING COUNT(*) = 2
    ) dup1

    JOIN dbo.Person p1 ON p1.PersonId = dup1.PID1
    JOIN dbo.Person p2 ON p2.PersonId = dup1.PID2

  UNION
   
    -- Duplicates DOB/FirstName
    
    SELECT dup2.*, 
      p3.ReverseName AS Name1, p4.ReverseName AS Name2,
      p3.NationalId AS NatId1, p4.NationalId AS NatId2,
      ( SELECT COUNT(*) FROM dbo.ClinEvent WHERE PersonId = dup2.PID1 ) AS CE1,
      ( SELECT COUNT(*) FROM dbo.ClinEvent WHERE PersonId = dup2.PID2 ) AS CE2,
      ( SELECT COUNT(*) FROM dbo.LabData WHERE PersonId = dup2.PID1 ) AS LD1,
      ( SELECT COUNT(*) FROM dbo.LabData WHERE PersonId = dup2.PID2 ) AS LD2
    FROM
    ( 
      SELECT 
        CONVERT(DATE,DOB) AS DOB,
        MIN(PersonId) AS PID1, MAX(PersonId) AS PID2
      FROM dbo.Person
      GROUP BY DOB,FstName
      HAVING COUNT(*) = 2
    ) dup2
    JOIN dbo.Person p3 ON p3.PersonId = dup2.PID1
    JOIN dbo.Person p4 ON p4.PersonId = dup2.PID2
    
  ) candidates

WHERE NatId1 IS NULL OR NatId2 IS NULL;
GO