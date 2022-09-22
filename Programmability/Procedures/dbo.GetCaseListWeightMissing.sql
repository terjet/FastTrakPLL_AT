SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetCaseListWeightMissing]( @StudyId INT ) AS
BEGIN
  /* Get list of patients with last weight date */
  SELECT vcl.PersonId,max(ce.EventTime) AS LastWeightDate
  INTO #weightDate FROM ViewActiveCaseListStub vcl
    LEFT OUTER JOIN ClinEvent ce ON ce.PersonId=vcl.PersonId
    LEFT OUTER JOIN ClinObservation co ON co.EventId=ce.EventId AND co.VarName='WEIGHT'
  WHERE vcl.StudyId=@StudyId AND ISNULL(co.Quantity,0) > 0
  GROUP BY vcl.PersonId;
  /* Select the list */
  SELECT vcl.PersonId,vcl.DOB,vcl.FullName,vcl.GroupName, ISNULL(dbo.LongTime(wd.LastWeightDate), 'Ingen vekt registrert!' ) AS InfoText
    FROM ViewActiveCaseListStub vcl
    JOIN #weightDate wd ON wd.PersonId=vcl.PersonId
  WHERE ( vcl.StudyId=@StudyId) AND ( getdate()-wd.LastWeightDate > 30  OR wd.LastWeightDate IS NULL )
  ORDER BY wd.LastWeightDate
END
GO