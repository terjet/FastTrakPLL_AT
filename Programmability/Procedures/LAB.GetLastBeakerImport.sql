SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [LAB].[GetLastBeakerImport]( @PersonId INT) AS
BEGIN
  SELECT ISNULL( MAX( ISNULL( ib.ClosedAt, ib.CreatedBy ) ), DATEADD( YEAR, -10, GETDATE()) ) AS LastImportDate
  FROM dbo.ImportBatch ib
  JOIN dbo.ImportContext ic ON ib.ContextId = ic.ContextId
  WHERE ic.ContextName = CONCAT( 'Epic.', @PersonId );
END;
GO

GRANT EXECUTE ON [LAB].[GetLastBeakerImport] TO [FastTrak]
GO