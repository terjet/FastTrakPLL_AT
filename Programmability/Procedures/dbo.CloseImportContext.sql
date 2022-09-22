SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CloseImportContext]( @ContextId INT, @LastUpdate DateTime = NULL )
AS
BEGIN 
  IF @LastUpdate IS NULL SET @LastUpdate = getdate();
  UPDATE ImportContext SET LastUpdate=@LastUpdate WHERE ContextId=@ContextId
    AND ( LastUpdate IS NULL OR LastUpdate < @LastUpdate );
END
GO