SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SignLabEntry]( @ResultId INT ) AS
BEGIN
  UPDATE dbo.LabData
  SET SignedBy = USER_ID(), SignedAt = GETDATE()
  WHERE ResultId = @ResultId AND SignedBy IS NULL;
END
GO

GRANT EXECUTE ON [dbo].[SignLabEntry] TO [Lege]
GO