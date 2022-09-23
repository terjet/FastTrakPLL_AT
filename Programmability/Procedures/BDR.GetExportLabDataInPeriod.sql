SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BDR].[GetExportLabDataInPeriod]( @StartAt DATETIME, @StopAt DATETIME ) AS
BEGIN

  SELECT p.NationalId, ld.LabDate AS LabDate, lc.LabClassId, cl.NLK, lc.LabName, ld.NumResult 
  FROM dbo.LabData ld 
    JOIN dbo.LabCode lc ON lc.LabCodeId = ld.LabCodeId 
    JOIN dbo.Person p ON p.PersonId = ld.PersonId AND p.TestCase = 0
    JOIN dbo.LabClass cl ON cl.LabClassId = lc.LabClassId 
    JOIN dbo.StudyCase sc ON sc.PersonId  = ld.PersonId 
    JOIN dbo.Study s ON s.StudyId  = sc.StudyId AND s.StudyName = 'BARNEDIABETES'
    WHERE lc.LabClassId IN ( 34, 35, 36, 37, 44, 48, 49, 315, 316, 318, 421, 422, 507, 509, 1058, 1085, 1087, 1088 ) 
      AND ld.LabDate BETWEEN @StartAt AND @StopAt 
   ORDER BY p.NationalId, lc.LabClassId, ld.LabDate;
   
END
GO

GRANT EXECUTE ON [BDR].[GetExportLabDataInPeriod] TO [Administrator]
GO