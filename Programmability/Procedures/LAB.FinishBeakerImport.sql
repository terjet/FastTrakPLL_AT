SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [LAB].[FinishBeakerImport] ( @PersonId INT, @StudyName VARCHAR(40) ) AS
BEGIN
  UPDATE dbo.Alert SET 
    AlertHeader = 'Labimport ferdig', 
    AlertMessage = 'Importen av labdata fra EPIC Beaker er ferdig', 
	AlertLevel = 0
  WHERE PersonId = @PersonId AND AlertClass = 'BEAKER';
END;
GO