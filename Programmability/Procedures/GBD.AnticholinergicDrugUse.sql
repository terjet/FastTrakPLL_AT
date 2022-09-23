SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[AnticholinergicDrugUse] AS
BEGIN
  DECLARE @Total FLOAT;
  SELECT @Total = COUNT(*)
    FROM dbo.Person p 
    JOIN dbo.StudCase sc ON sc.PersonId=p.PersonId AND sc.StudyId=2
    JOIN dbo.StudyStatus ss ON ss.StudyId=sc.StudyId AND ss.StatusId=sc.FinState AND ss.StatusActive=1
    JOIN dbo.StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId=sc.GroupId AND sg.GroupActive=1 
    JOIN dbo.StudyCenter c ON c.CenterId=sg.CenterId AND c.CenterActive=1;
  SELECT kb.ATC,kb.DrugName,kb.AlertLevel,count(*) as Antall,count(*) / @Total * 100 as PercentUse
    FROM dbo.KBAnticholinDrug kb join dbo.OngoingTreatment ot on ot.ATC=kb.ATC
    JOIN dbo.Person p ON p.PersonId=ot.PersonId
    JOIN dbo.StudCase sc ON sc.PersonId=p.PersonId AND sc.StudyId=2
    JOIN dbo.StudyStatus ss ON ss.StudyId=sc.StudyId AND ss.StatusId=sc.FinState AND ss.StatusActive=1
    JOIN dbo.StudyGroup sg ON sg.StudyId=sc.StudyId AND sg.GroupId=sc.GroupId AND sg.GroupActive=1
    JOIN dbo.StudyCenter c ON c.CenterId=sg.CenterId AND c.CenterActive=1
  GROUP BY kb.ATC,kb.DrugName,kb.AlertLevel 
  ORDER BY count(*) DESC
END
GO

GRANT EXECUTE ON [GBD].[AnticholinergicDrugUse] TO [FastTrak]
GO