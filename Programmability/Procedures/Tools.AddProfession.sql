SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [Tools].[AddProfession]( @ProfType VARCHAR(3), @ProfName VARCHAR(32) ) AS
BEGIN
  SET NOCOUNT ON;
  IF NOT EXISTS( SELECT 1 FROM dbo.MetaProfession WHERE ProfType = @ProfType ) 
  BEGIN
    INSERT INTO dbo.MetaProfession (OID9060, ProfName)
      VALUES (@ProfType, @ProfName);
    PRINT ' ++ The profession ' + @ProfName + ' was added to the database.';
  END
  ELSE
    PRINT '    The profession ' + @ProfName + ' is already on the database.';
END
GO