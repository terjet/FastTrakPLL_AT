SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[VerifyStudyName]( @StudyName VARCHAR(40) ) AS
BEGIN
  SET XACT_ABORT ON;
  IF ISNULL(@StudyName, '') = '' 
    RAISERROR ('Fagjournal er ikke spesifisert!', 16, 1);
  IF NOT EXISTS( SELECT 1 FROM dbo.Study WHERE StudyName = @StudyName )
    RAISERROR ( 'Fagjournalen "%s" mangler i denne databasen.\nDenne må kanskje lisensieres separat fra DIPS AS.', 16, 1, @StudyName );
END;
GO