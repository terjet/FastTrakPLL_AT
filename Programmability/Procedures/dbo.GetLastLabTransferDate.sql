SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetLastLabTransferDate] ( @PersonId INT, @BatchId INT )
AS
BEGIN
  SELECT Max( CreatedAt ) FROM LabData WHERE PersonId=@PersonId AND BatchId=@BatchId;
END
GO

GRANT EXECUTE ON [dbo].[GetLastLabTransferDate] TO [FastTrak]
GO