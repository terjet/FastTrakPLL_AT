﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetProblemLists] AS
BEGIN
  SELECT ListId,ListName FROM MetaNomList WHERE ListId IN (4,11) AND ListActive=1
END
GO

GRANT EXECUTE ON [dbo].[GetProblemLists] TO [FastTrak]
GO