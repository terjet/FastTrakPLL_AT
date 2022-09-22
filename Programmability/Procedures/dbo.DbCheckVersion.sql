SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DbCheckVersion]( @DbVer INT )
AS
BEGIN
  DECLARE @CurrVersion INT;
  SET @CurrVersion = dbo.DbVersion();
  IF @CurrVersion <> @DbVer
   RAISERROR( 'Upgrade requires version %d. Your version is %d!',18,1,@DbVer,@CurrVersion)
END
GO

GRANT EXECUTE ON [dbo].[DbCheckVersion] TO [FastTrak]
GO