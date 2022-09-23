SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListWarfarinNSAID]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, v.GenderId, dt1.DrugName + ' - ' + dt2.DrugName AS InfoText
  FROM dbo.OngoingTreatment dt1 
  JOIN dbo.OngoingTreatment dt2 ON dt1.PersonId = dt2.PersonId AND dt1.TreatId <> dt2.TreatId
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = dt1.PersonId AND v.StudyId = @StudyId
  WHERE ( dt1.ATC LIKE 'B01AA%' OR dt1.ATC LIKE 'B01AF%' ) AND dt2.ATC LIKE 'M01A%'
  ORDER BY v.FullName;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListWarfarinNSAID] TO [Farmasøyt]
GO

GRANT EXECUTE ON [dbo].[GetCaseListWarfarinNSAID] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListWarfarinNSAID] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListWarfarinNSAID] TO [Vernepleier]
GO