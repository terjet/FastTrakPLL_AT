SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListNextINR]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId, v.DOB, v.FullName, v.GroupName, 
      'Neste dosering ' + CONVERT( VARCHAR, MAX( cdp.DTVal ), 104 ) AS InfoText
  FROM dbo.ClinDataPoint cdp 
  JOIN dbo.ClinEvent ce ON ce.EventId = cdp.EventId 
  JOIN dbo.ViewActiveCaseListStub v ON v.PersonId = ce.PersonId
  JOIN dbo.OngoingTreatment dt ON dt.PersonId = v.PersonId AND dt.ATC = 'B01AA03'
  WHERE v.StudyId = @StudyId AND cdp.ItemId = 3999  
  GROUP BY v.PersonId, v.DOB, v.FullName, v.GroupName
  ORDER BY MAX( cdp.DTVal );
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListNextINR] TO [Lege]
GO

GRANT EXECUTE ON [dbo].[GetCaseListNextINR] TO [Sykepleier]
GO

GRANT EXECUTE ON [dbo].[GetCaseListNextINR] TO [Vernepleier]
GO