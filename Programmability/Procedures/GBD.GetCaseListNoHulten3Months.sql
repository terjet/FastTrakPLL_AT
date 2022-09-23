﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [GBD].[GetCaseListNoHulten3Months]( @StudyId INT ) AS
BEGIN
  EXEC GetCaseListLastForm @StudyId,'HULTEN',90
END
GO

GRANT EXECUTE ON [GBD].[GetCaseListNoHulten3Months] TO [FastTrak]
GO