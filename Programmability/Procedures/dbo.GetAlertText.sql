SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetAlertText]( @AlertClass VARCHAR(12), @AlertFacet VARCHAR(16), 
  @AlertHeader VARCHAR(64) OUTPUT, @AlertMessage VARCHAR(512) OUTPUT )
AS
BEGIN
  SELECT @AlertHeader = TextValue FROM TextItems WHERE ScopeName=@AlertClass AND KeyName=@AlertFacet + '.Header';                 
  SELECT @AlertMessage = TextValue FROM TextItems WHERE ScopeName=@AlertClass AND KeyName=@AlertFacet;
  SET @AlertHeader = ISNULL(@AlertHeader,'@' + @AlertClass + '.' + @AlertFacet + '.Header' );
  SET @AlertMessage = ISNULL(@AlertMessage,'@' + @AlertClass + '.' + @AlertFacet );
END
GO