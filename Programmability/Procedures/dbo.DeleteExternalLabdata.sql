﻿SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteExternalLabdata]( @PersonId INT ) AS
BEGIN
  DELETE FROM LabData WHERE PersonId=@PersonId AND ISNULL(BatchId,0)<>0
END
GO

GRANT EXECUTE ON [dbo].[DeleteExternalLabdata] TO [superuser]
GO