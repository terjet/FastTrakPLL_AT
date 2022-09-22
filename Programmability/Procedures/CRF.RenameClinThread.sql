SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [CRF].[RenameClinThread]( @ThreadId INT, @ThreadName VARCHAR(24) )
AS
BEGIN
  -- Fails if existing thread with the same name, unique index
  UPDATE ClinThread SET ThreadName = @ThreadName WHERE ThreadId=@ThreadId; 
END
GO

GRANT EXECUTE ON [CRF].[RenameClinThread] TO [FastTrak]
GO