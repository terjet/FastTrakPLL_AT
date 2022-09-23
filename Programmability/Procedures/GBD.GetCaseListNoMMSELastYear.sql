﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListNoMMSELastYear]( @StudyId INT ) AS
BEGIN
  EXEC GetCaseListLastForm @StudyId, 'MMSE_NR3',365
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoMMSELastYear] TO [FastTrak]
GO