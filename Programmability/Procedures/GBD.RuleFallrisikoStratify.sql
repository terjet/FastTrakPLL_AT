SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[RuleFallrisikoStratify] (@StudyId INT, @PersonId INT) AS
BEGIN
  IF dbo.GetLastCompleteForm(@StudyId, @PersonId, 'STRATIFY') IS NULL
    EXEC dbo.AddAlertForDSSRule @StudyId, @PersonId, 2, 'STRATIFY', 'DataMissing';
  ELSE
   EXEC dbo.AddAlertForDSSRule @StudyId, @PersonId, 0, 'STRATIFY', 'DataFound';
END
GO

GRANT EXECUTE ON [GBD].[RuleFallrisikoStratify] TO [FastTrak]
GO