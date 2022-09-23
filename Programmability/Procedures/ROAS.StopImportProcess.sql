SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[StopImportProcess] AS
BEGIN

  -- INSERTs
  
  DENY INSERT ON dbo.ClinEvent TO public AS dbo;
  DENY INSERT ON dbo.ClinDataPoint TO public AS dbo;
  DENY INSERT ON dbo.ClinForm TO public AS dbo;
  DENY INSERT ON dbo.Person TO public AS dbo;
  DENY INSERT ON dbo.UserList TO public AS dbo;
  DENY INSERT ON dbo.UserLog TO public AS dbo;
  DENY INSERT ON dbo.ClinTouch TO public AS dbo;
  
  --- UPDATEs
  
  DENY UPDATE ON dbo.ClinEvent TO public AS dbo;
  DENY UPDATE ON dbo.ClinDataPoint TO public AS dbo;
  DENY UPDATE ON dbo.ClinForm TO public AS dbo;
  DENY UPDATE ON dbo.ClinTouch TO public AS dbo;
  DENY UPDATE ON dbo.Person TO public AS dbo;
  DENY UPDATE ON dbo.UserList TO public AS dbo;
  DENY UPDATE ON dbo.UserLog TO public AS dbo;
  
END
GO

GRANT EXECUTE ON [ROAS].[StopImportProcess] TO [Administrator]
GO