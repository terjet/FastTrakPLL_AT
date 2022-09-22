SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNextINR]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId,v.DOB,v.FullName,v.GroupName,'Neste dosering ' + CONVERT(varchar,MAX(co.DTVal),104) AS InfoText
    FROM ClinObservation co 
    JOIN ClinEvent ce ON ce.EventId=co.EventId 
    JOIN ViewActiveCaseListStub v on v.PersonId=ce.PersonId
    JOIN OngoingTreatment dt ON dt.PersonId=v.PersonId AND dt.ATC='B01AA03'
  WHERE v.StudyId=@StudyId AND co.VarName='WARFARIN_NEXT'  
  GROUP BY v.PersonId,v.DOB,v.FullName,v.GroupName
  ORDER BY MAX(co.DTVal)
END
GO