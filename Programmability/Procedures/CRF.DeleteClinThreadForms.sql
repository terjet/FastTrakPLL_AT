SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[DeleteClinThreadForms]( @ClinFormId INT ) AS
BEGIN
  DELETE ct FROM dbo.ClinThread ct
  JOIN CRF.ClinThreadForm ctf ON ctf.ThreadId = ct.ThreadId
  WHERE ctf.ClinFormId = @ClinFormId
END
GO