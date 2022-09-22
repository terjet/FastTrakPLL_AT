SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ReportDrugUsagePerCenter]( @ATCLevel INT = 5 ) AS
BEGIN
  SELECT k.ATCCode AS ATC,k.ATCName,c.CenterName,
    dbo.GetActiveCasesAtStudyCenter(sc.StudyId,c.CenterId,NULL) AS Patients,count(dt.TreatId) AS UsedBy 
  INTO #DrugStats
  FROM DrugTreatment dt
    JOIN KBAtcIndex k ON k.ATCCode=substring(dt.ATC,1,@ATCLevel)
    JOIN dbo.Person p ON p.PersonId=dt.PersonId
    JOIN dbo.StudCase sc ON sc.PersonId=p.PersonId
    JOIN dbo.StudyGroup sg ON sg.GroupId=sc.GroupId AND sg.StudyId=sc.StudyId
    JOIN dbo.StudyStatus ss ON ss.StatusId=sc.FinState AND ss.StudyId=sc.StudyId AND ss.StatusActive=1
    JOIN dbo.StudyCenter c ON c.CenterId=sg.CenterId
    WHERE dt.StopAt IS NULL AND sc.StudyId=2
    GROUP BY k.ATCCode,k.AtcName,sg.CenterId,c.CenterName,dbo.GetActiveCasesAtStudyCenter(sc.StudyId,c.CenterId,NULL)
    ORDER BY c.CenterName,k.ATCCode
  ALTER TABLE #DrugStats ADD PercentUse DECIMAL(5,2);
  UPDATE #DrugStats SET PercentUse = UsedBy/Patients*100;
  SELECT * FROM #DrugStats WHERE Patients > 10 ORDER BY PercentUse DESC
END
GO