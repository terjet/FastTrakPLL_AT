﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteLabCode]( @LabCodeId INT ) AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM dbo.LabCode WHERE LabCodeId = @LabCodeId;
END
GO

GRANT EXECUTE ON [dbo].[DeleteLabCode] TO [superuser]
GO