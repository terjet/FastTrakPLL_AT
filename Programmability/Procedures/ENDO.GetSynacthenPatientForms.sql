SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ENDO].[GetSynacthenPatientForms]( @StudyId INT ) AS
BEGIN
  SELECT v.PersonId,v.DOB, v.FullName, v.GroupName, 'Synacthenskjema: ' + dbo.ShortTime( f.EventTime) AS InfoText
  FROM dbo.GetLastFormTable( 519, NULL ) f
  JOIN  dbo.ViewCaseListStub v on v.PersonId = f.PersonId
  WHERE StudyId = @StudyId
END
GO

GRANT EXECUTE ON [ENDO].[GetSynacthenPatientForms] TO [FastTrak]
GO