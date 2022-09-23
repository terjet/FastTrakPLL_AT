SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Config].[UpdateCovid19StatusCodes] AS
BEGIN
  SET NOCOUNT ON;        
  DECLARE @StudyId INT;
  SELECT @StudyId = StudyId FROM dbo.Study WHERE StudyName = 'COVID-19';
  IF NOT @StudyId IS NULL
  BEGIN
    EXEC dbo.AddStudyStatus @StudyId,1, 'A - Ukjent status', 1;
    EXEC dbo.AddStudyStatus @StudyId,2, 'B - Mistenkt tilfelle', 1;
    EXEC dbo.AddStudyStatus @StudyId,3, 'C - Bekreftet tilfelle', 1;
    EXEC dbo.AddStudyStatus @StudyId,4, 'D - Friskmeldt', 0
    EXEC dbo.AddStudyStatus @StudyId,23, 'T - Testpasient', 0;
    EXEC dbo.AddStudyStatus @StudyId,24, 'U - Utskrevet / avsluttet', 0;
    EXEC dbo.AddStudyStatus @StudyId,25, 'X - Ingen mistanke', 1;
    EXEC dbo.AddStudyStatus @StudyId,26, 'Y - Negativ prøve', 1;
    EXEC dbo.AddStudyStatus @StudyId,27, 'Z - Død av COVID-19 ', 1;
    EXEC dbo.AddStudyStatus @StudyId,28, 'ZZ - Død, smittesporing avsluttet', 0;
  END;
END
GO

GRANT EXECUTE ON [Config].[UpdateCovid19StatusCodes] TO [Administrator]
GO