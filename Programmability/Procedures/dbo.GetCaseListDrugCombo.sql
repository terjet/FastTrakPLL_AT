SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCaseListDrugCombo]( @StudyId INT, @ATC1 VARCHAR(7), @ATC2 VARCHAR(7) ) AS
BEGIN
  SELECT vcl.*, 
    d1.DrugName + ' - ' + d2.DrugName AS InfoText
  FROM dbo.ViewActiveCaseListStub vcl
    JOIN dbo.OngoingTreatment d1 ON d1.PersonId = vcl.PersonId AND d1.ATC LIKE @ATC1
    JOIN dbo.OngoingTreatment d2 ON d2.PersonId = vcl.PersonId AND d2.ATC LIKE @ATC2
  WHERE vcl.StudyId = @StudyId  
  ORDER BY FullName;
END
GO

GRANT EXECUTE ON [dbo].[GetCaseListDrugCombo] TO [Administrator]
GO