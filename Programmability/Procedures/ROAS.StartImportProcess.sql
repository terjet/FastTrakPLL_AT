SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [ROAS].[StartImportProcess] AS
BEGIN

  -- The REVOKE statements are offensive to Visual Studio, but not to MS SQL Server.
  -- This is an old bug without priority:
  -- https://developercommunity.visualstudio.com/t/ssdt-reports-revoke-statements-are-only-supported/180209

  -- INSERTs
  
  REVOKE INSERT ON dbo.ClinEvent TO public AS dbo;
  REVOKE INSERT ON dbo.ClinDataPoint TO public AS dbo;
  REVOKE INSERT ON dbo.ClinForm TO public AS dbo;
  REVOKE INSERT ON dbo.Person TO public AS dbo;
  REVOKE INSERT ON dbo.UserList TO public AS dbo;
  REVOKE INSERT ON dbo.UserLog TO public AS dbo;
  REVOKE INSERT ON dbo.ClinTouch TO public AS dbo;
  
  --- UPDATEs
  
  REVOKE UPDATE ON dbo.ClinEvent TO public AS dbo;
  REVOKE UPDATE ON dbo.ClinDataPoint TO public AS dbo;
  REVOKE UPDATE ON dbo.ClinForm TO public AS dbo;
  REVOKE UPDATE ON dbo.ClinTouch TO public AS dbo;
  REVOKE UPDATE ON dbo.Person TO public AS dbo;
  REVOKE UPDATE ON dbo.UserList TO public AS dbo;
  REVOKE UPDATE ON dbo.UserLog TO public AS dbo;
  
END
GO

GRANT EXECUTE ON [ROAS].[StartImportProcess] TO [Administrator]
GO