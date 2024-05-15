SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [NDV].[UpdateItemVisibility] AS
BEGIN
  SET NOCOUNT ON;
  IF DB_NAME() = 'EFT00048' -- AHUS
  BEGIN
   -- Har et prosjekt for digital oppfølgning, og bruker variable for å holde orden på dette her:
    UPDATE dbo.MetaFormItem SET Visibility = 0 
    WHERE 
      ItemId IN ( 12749, 12755 ) AND 
      FormId IN ( SELECT FormId FROM dbo.MetaForm WHERE FormName IN ( 'DIAPOL_GRAVIDE', 'DIAPOL_MAIN', 'DIAPOL_YEAR' ) );
  END;
END
GO

GRANT EXECUTE ON [NDV].[UpdateItemVisibility] TO [Administrator]
GO