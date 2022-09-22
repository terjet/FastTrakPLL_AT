SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [LAB].[StartBeakerImport] (@PersonId INT, @StudyName VARCHAR(40) ) AS
BEGIN
  DECLARE @StudyId INT;
  SELECT @StudyId = StudyId FROM dbo.Study 
  WHERE StudyName = @StudyName;
  EXEC dbo.AddAlertForPerson @StudyId, @PersonId, 4, 'BEAKER','DataMissing',  
	  'Labimport startet', 
	  'Vi henter inn labdata fra integrasjonene, labdata er ikke oppdatert';
END;
GO

GRANT EXECUTE ON [LAB].[StartBeakerImport] TO [FastTrak]
GO