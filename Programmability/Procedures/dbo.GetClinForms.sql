SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetClinForms] (@StudyId INT, @PersonId INT, @ClinFormId INT = NULL) AS
BEGIN
  SET NOCOUNT ON;
  IF @ClinFormId IS NULL
    EXEC CRF.GetClinFormList @StudyId, @PersonId, 1
  ELSE
    EXEC CRF.GetClinForm @ClinFormId
END
GO