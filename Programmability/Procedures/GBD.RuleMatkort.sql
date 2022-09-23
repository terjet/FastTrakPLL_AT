SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleMatkort]( @StudyId INT, @PersonId INT )
AS
BEGIN
  DECLARE @AlertFacet varchar(16);
  DECLARE @AlertLevel INT;
  DECLARE @RevisionDate DateTime;

  SELECT @RevisionDate = dbo.GetLastDTVal( @PersonId,'MAT_Revisjonsdato' );
  IF @RevisionDate IS NULL BEGIN
    SET @AlertFacet = 'Exclude';
    SET @AlertLevel = 0;
  END
  ELSE IF @RevisionDate < GETDATE() BEGIN
    SET @AlertFacet = 'DataOld';
    SET @AlertLevel = 3;
  END
  ELSE BEGIN
    SET @AlertFacet = 'DataFound';
    SET @AlertLevel = 0;
  END;
  EXEC dbo.AddAlertForDSSRule @StudyId, @PersonId, @AlertLevel, 'MATKORT', @AlertFacet;
END;
GO

GRANT EXECUTE ON [GBD].[RuleMatkort] TO [FastTrak]
GO