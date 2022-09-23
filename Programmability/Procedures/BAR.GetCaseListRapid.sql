﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [BAR].[GetCaseListRapid]( @StudyId INT ) AS
BEGIN
  EXEC dbo.GetCaseListByFormName @StudyId, 'BAR_RAPID';
END
GO

GRANT EXECUTE ON [BAR].[GetCaseListRapid] TO [FastTrak]
GO